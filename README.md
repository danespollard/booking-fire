# Booking Fire

Booking Fire is an availability tracker for musicians, freelancers, and public speakers who book their own dates. Keep a calendar of which days are open, on hold, or booked, then copy a ready-to-send availability message for clients, venues, and event organizers in one tap.

## Features

- **Availability calendar** — Mark any day as **Open**, **Hold**, or **Booked**, with an optional time window (Anytime, Daytime, Evening, After 9pm) and client name.
- **Openings messages** — The current month's availability is rendered into message templates you can copy straight into a text, DM, or email. It updates live as you edit the calendar.
- **Custom templates** — Write and reorder your own templates using placeholders. Three defaults (Short, Full List, By Weekday) are created for every new account.
- **Plain-text endpoint** — `GET /openings.txt` returns a rendered template for a date range.
- **Mobile-first** — Responsive layout with a bottom-sheet day editor, installable as a PWA.
- **Accounts** — Email/password sign-up, sign-in, and password reset.

## Template placeholders

| Placeholder | Output |
| --- | --- |
| `{open_dates}` | Open dates, inline and comma-separated |
| `{open_dates_list}` | Open dates, one per line |
| `{open_dates_grouped}` | Open dates grouped by weekday |
| `{hold_dates}` | Held dates, inline |
| `{hold_dates_list}` | Held dates, one per line |
| `{booked_dates}` | Booked dates, inline |
| `{booked_dates_list}` | Booked dates, one per line |

Example:

```
I'm open: {open_dates}. Want me to hold one?
```

### `/openings.txt` parameters

| Param | Default |
| --- | --- |
| `from` | First day of the current month |
| `to` | Last day of the current month |
| `template_id` | Your first template |

Requires a signed-in session.

## Stack

- Ruby 3.4.12, Rails 8.1
- PostgreSQL
- Hotwire (Turbo + Stimulus), Importmap, Propshaft
- Tailwind CSS
- Solid Queue, Solid Cache, Solid Cable
- Kamal for deployment

## Getting started

Prerequisites: Ruby 3.4.12 and a running PostgreSQL server.

```sh
bin/setup
```

This installs gems, prepares the database, and starts the dev server. On later runs:

```sh
bin/dev
```

The app runs at http://localhost:3000. Seeds create a test account: `test@example.com` / `password`.

## Architecture

Booking Fire follows a few rules so the code stays predictable as it grows:

- **Only the seven standard actions.** Controllers use `index`, `show`, `new`, `create`, `edit`, `update` and `destroy`, and nothing else. A new verb means a new resource: changing the openings date range is `PATCH /openings_range`, not a custom action on another controller.
- **Routes list only what exists.** Every `resources` line uses `only:`, so the route table matches the controllers.
- **Months are a resource.** `GET /months/2026-11` shows a month, and `/` shows the current one. The `Month` model handles parsing, neighbors and weeks.
- **GET never writes.** Data a page needs, like the default templates, is created when its owner is created.
- **Turbo Stream responses live in views.** Each action that answers with a stream has a `.turbo_stream.erb` template next to its HTML views. Controllers only pick the format.
- **Partials take locals.** A partial reads only what it's passed, never `Current` or instance variables, so it renders the same from a page, a stream or a test.
- **Endpoints refuse formats they don't serve.** `/openings` answers in plain text and returns 406 for anything else.

## Testing and checks

```sh
bin/rails test
bin/rubocop
bin/brakeman
```

## Deployment

The app ships with a `Dockerfile` and a Kamal config in `config/deploy.yml`. Secrets are read from the environment and `config/master.key` via `.kamal/secrets`; never commit raw credentials.

```sh
bin/kamal setup
bin/kamal deploy
```

## Roadmap

See [ROADMAP.md](ROADMAP.md) for where Booking Fire is headed. Highlights:

- **Holds that work like the business does**: first and second holds, challenges, expiry and follow-ups
- **Calendar sync** with Apple Calendar, Google, Outlook and any CalDAV server, including self-hosted and open-source options
- **Band calendars** that find dates when every member is free, with sub lists
- **Open data**: a public API, webhooks, full export, and a command-line client
- **Integrations** with gig marketplaces, payments, contracts, Shortcuts and text expanders

## License

Booking Fire is licensed under the [Mozilla Public License 2.0](LICENSE).
