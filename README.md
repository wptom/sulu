<br/>
<p align="center">
    <a href="https://sulu.io/" target="_blank">
        <img width="50%" src="https://sulu.io/website/images/sulu.svg" alt="Sulu logo">
    </a>
</p>

<br/>
<p align="center">
    <a href="LICENSE" target="_blank">
        <img src="https://img.shields.io/github/license/sulu/skeleton.svg" alt="GitHub license">
    </a>
    <a href="https://github.com/sulu/skeleton/releases" target="_blank">
        <img src="https://img.shields.io/github/tag/sulu/skeleton.svg" alt="GitHub tag (latest SemVer)">
    </a>
    <a href="https://github.com/sulu/skeleton/actions" target="_blank">
        <img src="https://img.shields.io/github/actions/workflow/status/sulu/skeleton/test-application.yaml" alt="Test workflow status">
    </a>
</p>
<br/>

[Sulu](https://sulu.io/) is a highly extensible open-source **PHP content management system based** on the [Symfony](https://symfony.com/) framework. Sulu is developed to deliver robust **multi-lingual and multi-portal websites** while providing an **intuitive and extensible administration interface** to manage the full content lifecycle. 

Have a look at the official [Sulu website](https://sulu.io/) for a comprehensive list of Sulus features, core values and use cases. 

<br/>
<p align="center">
    <img width="80%" src="https://sulu.io/uploads/media/800x@2x/07/167-ezgif.gif?v=2" alt="Sulu Slideshow">
</p>
<br/>

This repository provides the recommended **project template for starting your new project based on the Sulu content management system**.
The project template follows the best-practices of the [Symfony](https://symfony.com/) framework and builds upon tho official [symfony/skeleton](https://github.com/symfony/skeleton) template. In addition, it requires and configures the Sulu content management system core framework [sulu/sulu](https://github.com/sulu/sulu).

If you want to **extend your already set up Sulu project**, visit the [Sulu organization](https://github.com/sulu) on GitHub for a complete list of official Sulu bundles.


## 🚀&nbsp; Instalace a spuštění (Docker)

### Požadavky

- [Docker](https://www.docker.com/) a [Docker Compose](https://docs.docker.com/compose/) (v2+)
- Git

### 1. Klonování projektu

```bash
git clone <repository-url> my-project
cd my-project
```

### 2. Sestavení a spuštění kontejnerů

```bash
docker compose up -d --build
```

Spustí tyto služby:

| Služba  | Popis                        | Port          |
|---------|------------------------------|---------------|
| `app`   | PHP 8.4-FPM (Symfony/Sulu)   | interní        |
| `nginx` | Webserver                    | `localhost:8000` |
| `db`    | MariaDB 10.11                | `localhost:13306` |
| `admin` | Node.js – webpack watch      | interní        |

### 3. Inicializace databáze a Sulu

```bash
docker compose exec app php bin/console sulu:build dev
```

Tento příkaz vytvoří databázové schéma, načte fixtures a vytvoří výchozího admin uživatele.

### 4. Přihlášení do administrace

Otevři [http://localhost:8000/admin](http://localhost:8000/admin) a přihlaš se:

- **Uživatel:** `admin`
- **Heslo:** `admin`

### 5. Vytvoření obsahu (Homepage)

1. V adminu jdi na **Pages**
2. Vyber webspace **Website** a jazyk (**en**, **cs**, nebo **de**)
3. Klikni na **+** a vytvoř stránku (typ `homepage`)
4. Ulož a **publikuj**
5. Pro další jazyky přepni jazyk v pravém horním rohu editoru

Web je dostupný na:
- [http://localhost:8000/en](http://localhost:8000/en)
- [http://localhost:8000/cs](http://localhost:8000/cs)
- [http://localhost:8000/de](http://localhost:8000/de)

---

## 🐳&nbsp; Docker příkazy

### Základní operace

```bash
# Spustit všechny kontejnery na pozadí
docker compose up -d

# Sestavit image a spustit (po změně Dockerfile)
docker compose up -d --build

# Zastavit všechny kontejnery
docker compose stop

# Zastavit a smazat kontejnery (data v volumes zůstanou)
docker compose down

# Zastavit a smazat kontejnery včetně volumes (smaže databázi!)
docker compose down -v
```

### Stav a logy

```bash
# Zobrazit stav kontejnerů
docker compose ps

# Logy všech služeb
docker compose logs

# Logy konkrétní služby (živě)
docker compose logs -f app
docker compose logs -f nginx
docker compose logs -f admin
```

### Práce s aplikací

```bash
# Spustit příkaz v PHP kontejneru
docker compose exec app php bin/console <příkaz>

# Symfony konzole – vymazání cache
docker compose exec app php -d memory_limit=512M bin/console cache:clear --env=dev

# Composer install / update
docker compose exec app composer install
docker compose exec app composer update

# Sulu build (inicializace/reset DB a fixtures)
docker compose exec app php bin/console sulu:build dev

# Sulu build pouze pro produkci (bez fixtures)
docker compose exec app php bin/console sulu:build prod
```

### Databáze

```bash
# Připojení k databázi přes klienta v kontejneru
docker compose exec db mariadb -usulu -psulu sulu

# Záloha databáze
docker compose exec db mariadb-dump -usulu -psulu sulu > backup.sql

# Obnova databáze ze zálohy
docker compose exec -T db mariadb -usulu -psulu sulu < backup.sql
```

### Assets (Node.js / Webpack)

```bash
# Jednorázový build assetů pro produkci
docker compose run --rm admin sh -c "npm install && npm run build"

# Spustit watch mode (automatická kompilace při změnách)
docker compose up -d admin
docker compose logs -f admin
```

### Restart a rebuild

```bash
# Restartovat jeden kontejner
docker compose restart app

# Znovu vytvořit kontejner (načte nové env proměnné)
docker compose up -d --force-recreate app

# Smazat a znovu sestavit image
docker compose build --no-cache app
docker compose up -d app
```


## ❤️&nbsp; Community and Contributions

The Sulu content management system is a **community-driven open source project** backed by various partner companies. We are committed to a fully transparent development process and **highly appreciate any contributions**. Whether you are helping us fixing bugs, proposing new feature, improving our documentation or spreading the word - **we would love to have you as part of the Sulu community**.


## 📫&nbsp; Have a question? Want to chat? Run into a problem?

We are happy to welcome you in our official [Slack channel](https://sulu.io/services-and-support)! Obviously you can always **reach out to us directly** via the [Sulu twitter account](https://twitter.com/sulu) or post your question on [StackOverflow](https://stackoverflow.com/questions/tagged/sulu) with the official `sulu` tag.


## 🤝&nbsp; Found a bug? Missing a specific feature?

Feel free to **file a new issue** with a respective title and description on the the [sulu/sulu](https://github.com/sulu/sulu/issues) repository. If you already found a solution to your problem, **we would love to review your pull request**! Have a look at our [contribution guidelines](http://docs.sulu.io/en/latest/developer/contributing/) to find out about our coding standards.


## ✅&nbsp; Requirements

Sulu 2.6 requires a **PHP version higher or equal to 8.2** and is compatible with **Symfony version 5.4 - 7.4**. Have a look at the `require` section in the [composer.json](https://github.com/sulu/sulu/blob/2.6/composer.json) of the [sulu/sulu](https://github.com/sulu/sulu) core framework to find an **up-to-date list of the requirements** of Sulu content management system.


## 📘&nbsp; License
The Sulu content management system is released under the under terms of the [MIT License](LICENSE).
