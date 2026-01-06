<?php

namespace App\DTO;

use App\DTO\User;
use Symfony\Component\Serializer\Annotation\SerializedName;

class UsersListResponse
{
    /**
     * @var User[]
     */
    private array $data = [];

    #[SerializedName('total_count')]
    private ?int $totalCount = null;

    #[SerializedName('current_page')]
    private ?int $currentPage = null;

    /**
     * @return User[]
     */
    public function getData(): array
    {
        return $this->data;
    }

    /**
     * @param User[] $data
     */
    public function setData(array $data): self
    {
        $this->data = $data;

        return $this;
    }

    public function getTotalCount(): ?int
    {
        return $this->totalCount;
    }

    public function setTotalCount(?int $totalCount): self
    {
        $this->totalCount = $totalCount;

        return $this;
    }

    public function getCurrentPage(): ?int
    {
        return $this->currentPage;
    }

    public function setCurrentPage(?int $currentPage): self
    {
        $this->currentPage = $currentPage;

        return $this;
    }
}
