<?php

namespace App\DTO;

class ImportStatus
{
    private ?string $status = null;

    private ?ImportResult $result = null;

    public function getStatus(): ?string
    {
        return $this->status;
    }

    public function setStatus(?string $status): self
    {
        $this->status = $status;

        return $this;
    }

    public function getResult(): ?ImportResult
    {
        return $this->result;
    }

    public function setResult(?ImportResult $result): self
    {
        $this->result = $result;

        return $this;
    }
}

class ImportResult
{
    private ?int $count = null;

    public function getCount(): ?int
    {
        return $this->count;
    }

    public function setCount(?int $count): self
    {
        $this->count = $count;

        return $this;
    }
}
