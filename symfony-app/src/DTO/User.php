<?php

namespace App\DTO;

use Symfony\Component\Validator\Constraints as Assert;
use Symfony\Component\Serializer\Annotation\Groups;
use Symfony\Component\Serializer\Annotation\SerializedName;

class User
{
    #[Groups(['read'])]
    private ?int $id = null;

    #[Assert\NotBlank]
    #[Assert\Type('string')]
    #[Groups(['read', 'write'])]
    #[SerializedName('first_name')]
    private ?string $firstName = null;

    #[Assert\NotBlank]
    #[Assert\Type('string')]
    #[Groups(['read', 'write'])]
    #[SerializedName('last_name')]
    private ?string $lastName = null;

    #[Assert\NotBlank]
    #[Assert\Date]
    #[Groups(['read', 'write'])]
    private ?string $birthdate = null; // YYYY-MM-DD format

    #[Assert\NotBlank]
    #[Assert\Choice(['male', 'female'])]
    #[Assert\Type('string')]
    #[Groups(['read', 'write'])]
    private ?string $gender = null;

    #[Groups(['read'])]
    #[SerializedName('inserted_at')]
    private ?string $insertedAt = null; // date-time format

    #[Groups(['read'])]
    #[SerializedName('updated_at')]
    private ?string $updatedAt = null; // date-time format

    public function getId(): ?int
    {
        return $this->id;
    }

    public function setId(?int $id): self
    {
        $this->id = $id;

        return $this;
    }

    public function getFirstName(): ?string
    {
        return $this->firstName;
    }

    public function setFirstName(?string $firstName): self
    {
        $this->firstName = $firstName;

        return $this;
    }

    public function getLastName(): ?string
    {
        return $this->lastName;
    }

    public function setLastName(?string $lastName): self
    {
        $this->lastName = $lastName;

        return $this;
    }

    public function getBirthdate(): ?string
    {
        return $this->birthdate;
    }

    public function setBirthdate(?string $birthdate): self
    {
        $this->birthdate = $birthdate;

        return $this;
    }

    public function getGender(): ?string
    {
        return $this->gender;
    }

    public function setGender(?string $gender): self
    {
        $this->gender = $gender;

        return $this;
    }

    public function getInsertedAt(): ?string
    {
        return $this->insertedAt;
    }

    public function setInsertedAt(?string $insertedAt): self
    {
        $this->insertedAt = $insertedAt;

        return $this;
    }

    public function getUpdatedAt(): ?string
    {
        return $this->updatedAt;
    }

    public function setUpdatedAt(?string $updatedAt): self
    {
        $this->updatedAt = $updatedAt;

        return $this;
    }
}
