<?php

namespace App\DTO;

class Error
{
    private ?string $error = null;

    public function getError(): ?string
    {
        return $this->error;
    }

    public function setError(?string $error): self
    {
        $this->error = $error;

        return $this;
    }
}
