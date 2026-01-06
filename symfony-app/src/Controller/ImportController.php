<?php

namespace App\Controller;

use App\Service\ApiClient;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use \Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\HttpFoundation\Request;

#[Route('/import')]
class ImportController extends AbstractController
{
    public function __construct(
        private ApiClient $apiClient
    ) {
    }

    #[Route('/', name: 'app_import_status', methods: ['GET'])]
    public function status(): Response
    {
        try {
            $importStatus = $this->apiClient->getImportStatus();
        } catch (\Throwable $e) {
            $this->addFlash('error', 'Failed to retrieve import status: ' . $e->getMessage());
            $importStatus = null;
        }

        return $this->render('import/status.html.twig', [
            'importStatus' => $importStatus,
        ]);
    }

    #[Route('/start', name: 'app_import_start', methods: ['POST'])]
    public function start(Request $request): Response
    {
        if ($this->isCsrfTokenValid('start_import', $request->request->get('_token'))) {
            try {
                $response = $this->apiClient->startImport();
                $this->addFlash('success', $response['status'] ?? 'Import process started successfully.');
            } catch (\Throwable $e) {
                $this->addFlash('error', 'Failed to start import: ' . $e->getMessage());
            }
        } else {
            $this->addFlash('error', 'Invalid CSRF token.');
        }

        return $this->redirectToRoute('app_import_status');
    }
}
