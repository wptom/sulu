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


## 🌍&nbsp; Vícejazyčná podpora (Multilang)

Sulu podporuje více jazyků přes konfiguraci webspace. Níže je kompletní postup, který bylo nutné provést pro zprovoznění `cs` a `de` vedle výchozího `en`.

### 1. Přidání localizací do webspace

V souboru [config/webspaces/website.xml](config/webspaces/website.xml) přidej nové jazyky do bloku `<localizations>`:

```xml
<localizations>
    <localization language="en" default="true"/>
    <localization language="cs"/>
    <localization language="de"/>
</localizations>
```

> ⚠️ Pokud jazyk není v `<localizations>`, Sulu ho v portálu odmítne s chybou `PortalLocalizationNotFoundException`.

### 2. Nastavení URL pro každý jazyk

Pokud je portál nakonfigurován tak, že všechny jazyky sdílí stejnou URL (`{host}`), Sulu nedokáže rozlišit, kde hledat obsah. Každý jazyk musí mít **unikátní URL prefix**:

```xml
<portals>
    <portal>
        <environments>
            <environment type="dev">
                <urls>
                    <url language="en">{host}/en</url>
                    <url language="cs">{host}/cs</url>
                    <url language="de">{host}/de</url>
                </urls>
            </environment>
            <!-- stejné i pro prod, stage, test -->
        </environments>
    </portal>
</portals>
```

Web je pak dostupný na:
- [http://localhost:8000/en](http://localhost:8000/en)
- [http://localhost:8000/cs](http://localhost:8000/cs)
- [http://localhost:8000/de](http://localhost:8000/de)

### 3. Přidání locales admin uživateli

Po přidání nových jazyků nemá admin uživatel automaticky oprávnění pro ně. Je nutné přiřadit nové locale do databáze:

```bash
docker compose exec db mariadb -usulu -psulu sulu -e "
UPDATE se_user_roles SET locale = '[\"en\",\"cs\",\"de\"]' WHERE idUsers = 1;
INSERT INTO se_user_roles (locale, idUsers, idRoles)
    SELECT '[\"en\",\"cs\",\"de\"]', 1, id FROM se_roles WHERE name = 'System Administrator';
"
```

> **Proč?** Sulu ukládá v `se_user_roles.locale` JSON pole povolených locales pro každou roli uživatele. Výchozí `sulu:build dev` nastaví pouze `["en"]`. Bez `cs` a `de` vrací admin preview chybu `Permission "view" in localization "cs" ... not granted`.

### 4. Vymazání cache

Po každé změně webspace konfigurace nebo oprávnění je nutné vymazat cache:

```bash
docker compose exec app php -d memory_limit=512M bin/console cache:clear --env=dev
```

### 5. Vytvoření obsahu pro nové jazyky

1. Přihlaš se na [http://localhost:8000/admin](http://localhost:8000/admin)
2. Jdi na **Pages**
3. Klikni na existující stránku (např. homepage v `en`)
4. V pravém horním rohu přepni jazyk na `cs`
5. Vyplň obsah v češtině a **publikuj**
6. Opakuj pro `de`

### Přehled souborů ke změně pro nový jazyk

| Soubor | Co změnit |
|--------|-----------|
| [config/webspaces/website.xml](config/webspaces/website.xml) | Přidat `<localization language="xx"/>` a URL prefix do všech `<environment>` bloků |
| Databáze `se_user_roles` | Přidat nový locale kód do JSON pole pro každého uživatele |

---

## 🔧&nbsp; Opravené problémy při nastavení

Při prvním spuštění projektu bylo nutné opravit několik problémů:

### 1. Dockerfile – chybějící adresář `var/`

**Problém:** `RUN mkdir -p public/bundles && chown -R www-data:www-data var public/bundles` selhal, protože adresář `var/` neexistoval.

**Oprava:** Příkaz byl změněn na `mkdir -p var public/bundles`.

### 2. `compose.yaml` – volume mount přepsal `vendor/`

**Problém:** Volume mount `. : /var/www/html` přepsal `vendor/` adresář, který byl nainstalován v Docker image při buildu. Protože `vendor/` je v `.gitignore`, na hostu neexistuje a Symfony hlásil „Dependencies are missing".

**Oprava:** Přidán pojmenovaný volume `vendor-data:/var/www/html/vendor`, který uchovává vendor adresář odděleně od mount-u hostitelského systému.

### 3. `compose.yaml` – OOM při `cache:clear` v composer post-install scriptu

**Problém:** `composer install` jako startup command spouštěl post-install skripty (vč. `cache:clear`), které selhaly kvůli výchozímu limitu paměti PHP 128 MB – Sulu potřebuje více.

**Oprava:** Přidán přepínač `--no-scripts` ke spouštěcímu příkazu `composer install`. Cache se sestaví při prvním request nebo při ručním `cache:clear -d memory_limit=512M`.

### 4. `var/` – oprávnění v kontejneru

**Problém:** Po namountování volume byl adresář `var/` vlastněn hostem, PHP-FPM (běžící jako `www-data`) do něj nemohl zapisovat.

**Oprava:** Spouštěcí příkaz kontejneru přidán `mkdir -p var && chown -R www-data:www-data var`.

### 5. Multilang – role „System Administrator" neexistuje

**Poznámka:** SQL v sekci Vícejazyčná podpora obsahuje `INSERT ... WHERE name = 'System Administrator'`. Příkaz `sulu:build dev` vytvoří pouze roli **User** (ne System Administrator), takže INSERT nevloží žádný záznam. Toto není chyba – `UPDATE se_user_roles` pro roli User stačí.

---

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
