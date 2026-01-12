<?php

namespace App\Controller;

use App\DTO\UsersListResponse;
use App\Form\UserType;
use App\DTO\User;
use App\Service\ApiClient;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/users')]
class UserController extends AbstractController
{
    public function __construct(
        private ApiClient $apiClient
    ) {
    }

    #[Route('/', name: 'app_user_index', methods: ['GET'])]
    public function index(Request $request): Response
    {
        $page = $request->query->getInt('page', 0);
        $search = $request->query->get('search');
        $birthdateFrom = $request->query->get('birthdate_from');
        $birthdateTo = $request->query->get('birthdate_to');
        $gender = $request->query->get('gender');
        $sortBy = $request->query->get('sort_by');
        $sortOrder = $request->query->get('sort_order');

        try {
            $usersListResponse = $this->apiClient->listUsers(
                $page,
                $search,
                $birthdateFrom,
                $birthdateTo,
                $sortBy,
                $sortOrder,
                $gender,
            );
            $users = $usersListResponse->getData();
        } catch (\Throwable $e) {
            $this->addFlash('error', 'Failed to load users: ' . $e->getMessage());
            $usersListResponse = new UsersListResponse(); // Create an empty response on error
            $users = [];
        }

        return $this->render('user/index.html.twig', [
            'users' => $users,
            'usersListResponse' => $usersListResponse, // Pass the full response object
            'search' => $search,
            'birthdateFrom' => $birthdateFrom,
            'birthdateTo' => $birthdateTo,
            'gender'=>$gender,
            'sortBy' => $sortBy,
            'sortOrder' => $sortOrder,
        ]);
    }

    #[Route('/new', name: 'app_user_new', methods: ['GET', 'POST'])]
    public function new(Request $request): Response
    {
        $user = new User();
        $form = $this->createForm(UserType::class, $user);

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            try {
                $this->apiClient->createUser($user);
                $this->addFlash('success', 'User created successfully.');
                return $this->redirectToRoute('app_user_index');
            } catch (\Throwable $e) {
                $this->addFlash('error', 'Failed to create user: ' . $e->getMessage());
            }
        }

        return $this->render('user/new.html.twig', [
            'user' => $user,
            'form' => $form,
        ]);
    }

    #[Route('/{id}', name: 'app_user_show', methods: ['GET'])]
    public function show(int $id): Response
    {
        try {
            $user = $this->apiClient->getUserById($id);
            if (!$user) {
                throw $this->createNotFoundException('User not found.');
            }
        } catch (\Throwable $e) {
            $this->addFlash('error', 'Failed to load user: ' . $e->getMessage());
            return $this->redirectToRoute('app_user_index');
        }

        return $this->render('user/show.html.twig', [
            'user' => $user,
        ]);
    }

    #[Route('/{id}/edit', name: 'app_user_edit', methods: ['GET', 'POST'])]
    public function edit(Request $request, int $id): Response
    {
        try {
            $user = $this->apiClient->getUserById($id);
            if (!$user) {
                throw $this->createNotFoundException('User not found.');
            }
        } catch (\Throwable $e) {
            $this->addFlash('error', 'Failed to load user for editing: ' . $e->getMessage());
            return $this->redirectToRoute('app_user_index');
        }

        $form = $this->createForm(UserType::class, $user);

        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            try {
                $this->apiClient->updateUser($id, $user);
                $this->addFlash('success', 'User updated successfully.');
                return $this->redirectToRoute('app_user_index');
            } catch (\Throwable $e) {
                $this->addFlash('error', 'Failed to update user: ' . $e->getMessage());
            }
        }

        return $this->render('user/edit.html.twig', [
            'user' => $user,
            'form' => $form,
        ]);
    }

    #[Route('/{id}', name: 'app_user_delete', methods: ['POST'])]
    public function delete(Request $request, int $id): Response
    {
        if ($this->isCsrfTokenValid('delete'.$id, $request->request->get('_token'))) {
            try {
                $this->apiClient->deleteUser($id);
                $this->addFlash('success', 'User deleted successfully.');
            } catch (\Throwable $e) {
                $this->addFlash('error', 'Failed to delete user: ' . $e->getMessage());
            }
        } else {
            $this->addFlash('error', 'Invalid CSRF token.');
        }

        return $this->redirectToRoute('app_user_index');
    }
}
