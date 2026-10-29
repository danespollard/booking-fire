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

- Ruby 3.4.2, Rails 8.0
- PostgreSQL
- Hotwire (Turbo + Stimulus), Importmap, Propshaft
- Tailwind CSS
- Solid Queue, Solid Cache, Solid Cable
- Kamal for deployment

## Getting started

Prerequisites: Ruby 3.4.2 and a running PostgreSQL server.

```sh
bin/setup
```

This installs gems, prepares the database, and starts the dev server. On later runs:

```sh
bin/dev
```

The app runs at http://localhost:3000. Seeds create a test account: `test@example.com` / `password`.

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

- **Public API** for reading and updating availability programmatically
- **Third-party integrations** to sync availability with the tools and calendars you already use
