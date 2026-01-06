<?php

namespace App\Service;

use Symfony\Contracts\HttpClient\HttpClientInterface;
use Symfony\Component\DependencyInjection\Attribute\Autowire;
use App\DTO\User;
use App\DTO\UsersListResponse;
use App\DTO\ImportStatus;
use App\DTO\Error;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\HttpFoundation\Response as HttpResponse; // Alias to avoid conflict with Symfony\Component\HttpFoundation\Response

class ApiClient
{
    private const API_SERVER_URL = '%env(API_BASE_URI)%';
    private const API_AUTH_TOKEN = '%env(API_TOKEN)%';

    public function __construct(
        private HttpClientInterface $httpClient,
        private SerializerInterface $serializer,
        #[Autowire(self::API_SERVER_URL)] private string $apiBaseUri,
        #[Autowire(self::API_AUTH_TOKEN)] private string $apiToken
    ) {
    }

    private function request(string $method, string $path, array $options = []): array
    {
        $response = $this->httpClient->request($method, $this->apiBaseUri . $path, array_merge_recursive($options, [
            'headers' => [
                'Authorization' => 'Bearer ' . $this->apiToken,
            ],
        ]));

        $statusCode = $response->getStatusCode();
        $content = $response->toArray(false); // Do not throw for 4xx/5xx

        if ($statusCode >= HttpResponse::HTTP_BAD_REQUEST) {
            $error = $this->serializer->deserialize(json_encode($content), Error::class, 'json');
            throw new \RuntimeException($error->getError() ?? 'API request failed with status ' . $statusCode);
        }

        return $content;
    }

    /**
     * Lists users with optional filtering and pagination.
     */
    public function listUsers(int $page = 0, ?string $search = null, ?string $birthdateFrom = null, ?string $birthdateTo = null, ?string $sortBy = null, ?string $sortOrder = null): UsersListResponse
    {
        $query = array_filter([
            'page' => $page,
            'search' => $search,
            'birthdate_from' => $birthdateFrom,
            'birthdate_to' => $birthdateTo,
            'sort_by' => $sortBy,
            'sort_order' => $sortOrder,
        ]);

        $content = $this->request('GET', '/users', [
            'query' => $query,
        ]);

        return $this->serializer->deserialize(json_encode($content), UsersListResponse::class, 'json');
    }

    /**
     * Creates a new user.
     */
    public function createUser(User $user): User
    {
        $content = $this->request('POST', '/users', [
            'json' => $this->serializer->normalize($user),
        ]);

        return $this->serializer->deserialize(json_encode($content), User::class, 'json');
    }

    /**
     * Retrieves a single user by their unique ID.
     */
    public function getUserById(int $id): ?User
    {
        try {
            $content = $this->request('GET', '/users/' . $id);
            return $this->serializer->deserialize(json_encode($content), User::class, 'json');
        } catch (\RuntimeException $e) {
            // Handle specific API error, e.g., 404 not found
            if (str_contains($e->getMessage(), 'not found')) { // This is a weak check, better to check status code directly if API client allows it
                return null;
            }
            throw $e;
        }
    }

    /**
     * Update an existing user by their unique ID.
     */
    public function updateUser(int $id, User $user): User
    {
        $content = $this->request('PUT', '/users/' . $id, [
            'json' => $this->serializer->normalize($user),
        ]);

        return $this->serializer->deserialize(json_encode($content), User::class, 'json');
    }

    /**
     * Delete a user by their unique ID.
     */
    public function deleteUser(int $id): void
    {
        $this->request('DELETE', '/users/' . $id);
    }

    /**
     * Initiates a new data import process.
     */
    public function startImport(): array
    {
        return $this->request('POST', '/import');
    }

    /**
     * Retrieves the current status of the data import process.
     */
    public function getImportStatus(): ImportStatus
    {
        $content = $this->request('GET', '/import');
        return $this->serializer->deserialize(json_encode($content), ImportStatus::class, 'json');
    }
}
