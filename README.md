# P&P (Phoenix and PHP) Project

Example project that uses both Elixir and Symfony.

This project is a monorepo containing two applications:

*   **Symfony Application**: A GUI for managing users and controlling import processes.
*   **Phoenix (Elixir) Application**: A RESTful API for user management and data import.

## Installation
This project requires Docker to run. Please ensure that Docker is installed and running before proceeding with the setup.

## Usage
After installation, you can start the project by running `docker-compose up -d` in the project root directory. This will start both the Elixir and Symfony services.

### Configuration
Please check the `.env` file for configuration options. You can customize the environment variables as per your requirements.

---

# PhoenixApp

This is a Phoenix application demonstrating user management and data import functionalities. It exposes a RESTful API for interacting with user data and managing import processes.

## Features

*   **User Management API:**
    *   Create, retrieve (single and list), update, and delete user records.
    *   Users have `first_name`, `last_name`, `birthdate`, and `gender`.
    *   List users with pagination, search by name, filter by birthdate range, and sort by various fields.
*   **Data Import API:**
    *   Initiate asynchronous data import processes.
    *   Retrieve the status of ongoing or completed import operations.
*   **API Token Authentication:**
    *   All API endpoints are secured using a bearer token (JWT-like) authentication mechanism.

## Installation and Setup

This project uses `docker-compose` for easy setup and local development. The Docker container handles all Elixir dependencies, so you do not need to install them on your host machine.

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    ```

2.  **Create a `.env` file:**
    Create a `.env` file in the project root based on the `.env.example` (if available, otherwise create it with necessary environment variables like `PHOENIX_PORT`).

    Example `.env` content:
    ```
    PHOENIX_PORT=4000
    ```

3.  **Build and run with Docker Compose:**
    ```bash
    docker-compose up --build
    ```

    The `docker-compose` command builds the image (which runs `mix deps.get`) and starts the application.

4.  **Access the API:**
    The API will be available at `http://localhost:<PHOENIX_PORT>/api`.
    You can refer to `openapi.yaml` for detailed API documentation.

## API Token

The API requires a token for authentication. During local development with `docker-compose`, the `API_TOKEN` is set via the `docker-compose.yaml` file. You can find and modify it there. The default token is `super-secret-api-token`. Include it in the `Authorization` header as a Bearer token:

`Authorization: Bearer super-secret-api-token`

---

# Symfony Application

This is a Symfony 7 application providing a graphical user interface (GUI) for managing users and controlling import processes. All data operations (User CRUD and Import Control) are API-backed, consuming an external API defined by an OpenAPI specification.

## Features

*   **User Management**: CRUD (Create, Read, Update, Delete) operations for user records.
*   **User Listing**: Displays a list of users with filtering (search, birthdate range), sorting by columns, and pagination.
*   **Import Control**: Initiate data import processes and view their current status.

*   **API-Backed**: All data interactions are performed against an external API defined by an OpenAPI specification, without using local Doctrine entities for these domains.

## Technologies Used

*   Symfony 7
*   PHP 8.2+
*   `kevinpapst/TablerBundle`
*   Symfony HttpClient
*   Symfony Serializer
*   Symfony Forms
*   Symfony AssetMapper (for frontend assets like `air-datepicker`)
*   Stimulus (for frontend interactivity)



## Development Environment

This project uses Docker for the runtime environment, but PHP dependencies are managed on your host machine.

1.  **Install Composer dependencies on your host:** Before starting the containers, you must install the PHP dependencies locally. 
    ```bash
    cd symfony-app
    composer install  # Or `php composer.phar install`
    cd .. # Return to the project root
    ```
    This command creates the `vendor` directory within `symfony-app`. You only need to run this command once initially and again if you modify the `composer.json` file.

2.  **Run the application from the project root:**
    ```bash
    docker-compose up
    ```

    The application will be available at the port specified by the `SYMFONY_PORT` environment variable in your `.env` file.

    The `docker-compose.yml` file is configured to mount the `symfony-app` directory (including the `vendor` folder) as a volume, so any changes you make to the code will be reflected in the running container.


## Usage

*   **User List**: Navigate to `/users` to view, filter, sort, and paginate user records.
*   **Create User**: Use the "New User" button on the user list page.
*   **Edit/View/Delete User**: Actions are available in the user list table.
*   **Import Control**: Navigate to `/import` to start a new import process or view its status.