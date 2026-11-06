# Booking Fire Roadmap

Booking Fire exists because answering "When are you free?" is the most repeated message a self-booked musician or speaker sends, and the tools built for it are wrong for the job. Booking links feel corporate, push work onto the buyer, and break the tone of a relationship built on texts and DMs. Booking Fire turns your calendar into a message you can paste anywhere, in your own voice, in seconds.

This roadmap covers where the product is today, what comes next, and the integrations that would make it the hub of a working performer's booking life.

## Who it's for

- **Gigging musicians** who book themselves: solo acts, cover bands, wedding and corporate bands, jazz players, church and pit musicians, DJs, side players who sub for other bands.
- **Public speakers and trainers** who juggle keynotes, workshops, virtual sessions and travel.
- **Anyone booked by the date** rather than by the hour: comedians, magicians, officiants, photographers, workshop leaders, tutors.

What they share: dates are the unit of sale, holds are normal, buyers reach out through every channel at once, and a slow reply loses the gig.

## Product principles

1. **The message is the product.** Every feature should end in better words to send, faster.
2. **Plain text first.** Output must look natural in iMessage, SMS, email, Messenger, Instagram and WhatsApp. No links required for the buyer.
3. **Phone first.** Most availability questions arrive on a phone, between sets or in an airport.
4. **Your calendar stays the source of truth.** Booking Fire reads from and writes to the calendars people already use rather than asking them to move.
5. **Booking language, not scheduling language.** Open, hold, first hold, challenge, booked, settled. The vocabulary of the business, not of meeting software.
6. **Never double-book.** Every feature that touches dates should make a conflict harder, not easier.
7. **Open and portable.** Everything works with Apple Calendar on iPhone, iPad and Mac, and with open-source calendar tools. Calendar data moves through open standards (iCalendar and CalDAV), every action is available through the API, and your data can leave in open formats at any time. People who run their own systems should be able to plug Booking Fire into them.

## Where it is today

- [x] Month calendar with Open, Hold and Booked days
- [x] Time window per day (Anytime, Daytime, Evening, After 9pm) and client name
- [x] Openings message rendered live from editable templates with placeholders
- [x] Three default templates (Short, Full List, By Weekday)
- [x] One-tap copy to clipboard
- [x] `GET /openings.txt` for a date range
- [x] Mobile bottom-sheet day editor, installable as a PWA
- [x] Email and password accounts with password reset

Known limits in the current version:

- One entry per day, so doubleheaders, a ceremony plus reception, or a morning keynote and evening gig can't both be recorded.
- No multi-day events (festivals, conferences, tours).
- Holds have no expiry, rank, or follow-up.
- No time zone handling beyond the server's.
- `/openings.txt` needs a signed-in browser session, so scripts and other apps can't use it.
- The message covers the current month only in the UI.
- Production deployment is not configured yet.

## Phase 0: Foundation

Work that every later phase depends on.

- [ ] **Multiple entries per day.** Replace the one-block-per-day rule with entries that have optional start and end times. Keep the simple "tap a day" flow for the common case.
- [ ] **Multi-day entries.** One booking spanning several dates, shown as a bar across the calendar.
- [ ] **Time zones.** Store a home time zone per user and a zone per entry, so a speaker booked in another region sees correct times.
- [ ] **Personal API tokens.** Let `/openings.txt` and future endpoints work with a revocable token, which unlocks scripts, shortcuts and text expanders.
- [ ] **`/openings.json`.** Structured output for widgets, integrations and the UI itself.
- [ ] **Seed data.** Realistic made-up calendars and templates so new contributors and demos start with something to look at.
- [ ] **Test coverage.** System tests for the calendar, day editor and copy flow; unit tests for every template placeholder.
- [ ] **Deployment.** Finish the Kamal configuration, backups, error reporting and uptime checks.
- [ ] **Account basics.** Email confirmation, account deletion, data export.

## Phase 1: Make the core loop great

The calendar-to-message loop is the whole pitch. It should feel instant and fit every situation.

### Messages and templates

- [ ] **Date range picker for the message.** Next 2 weeks, next 30/60/90 days, a specific month, or a custom range.
- [ ] **Filters per template.** Weekends only, evenings only, exclude holds, only dates within driving range of a city.
- [ ] **More placeholders.** First name of the person asking, count of open dates, next open date, time window per date, hold expiry, custom footer text.
- [ ] **Date format options.** `Fri 2/20`, `Friday, February 20`, `20/2`, with or without weekday, with or without year.
- [ ] **Template presets by gig type.** Bars and clubs (evenings), weddings (weekends plus travel buffer), corporate (weekdays, daytime), private events (includes set length and rate line), keynotes (includes travel days).
- [ ] **Template preview with sample data** while editing.
- [ ] **Languages.** Templates and date formatting in Spanish, French, Portuguese and more.
- [ ] **Reply snippets.** Ready messages for the next step: confirm a hold, release a hold, decline politely, ask for a deposit.

### Holds

Holds are where the real business happens and where most tools fall down.

- [ ] **Hold ranks.** First hold, second hold, third hold on the same date, in the order the industry uses.
- [ ] **Challenges.** When a firm offer arrives for a date with an earlier hold, prompt the holder to confirm or release by a deadline.
- [ ] **Hold expiry.** "Hold for The Blue Room until Wed" with a reminder before it lapses and automatic release if chosen.
- [ ] **Hold follow-up drafts.** A one-tap message asking the holder to confirm.
- [ ] **Holds in the message.** Optional line such as "Sat 2/21 is on hold until Wed, but I can let you know if it frees up."

### Faster input

- [ ] **Recurring defaults with exceptions.** "Usually free Thu–Sat evenings," then block out travel, rehearsals and bookings.
- [ ] **Drag and range select** to mark many days at once.
- [ ] **Keyboard shortcuts.** O, H and B for Open, Hold and Booked, arrow keys to move between days.
- [ ] **Quick add from text.** Type or dictate "booked Fri the 20th at the Blue Room, 8 to 11" and confirm.
- [ ] **Week and agenda views** alongside the month grid.
- [ ] **Undo** for every calendar change.

### Offline and mobile

- [ ] **Offline calendar and copy** through the service worker, syncing when back online.
- [ ] **Home screen widget style view** showing the next open dates and a copy button.
- [ ] **Web Share** so the message goes straight into Messages, WhatsApp or Mail from the PWA.

## Phase 2: Calendar sync

Most performers already keep a calendar. Booking Fire should never make them enter a gig twice.

- [ ] **ICS feed out.** A private subscription URL so bookings and holds appear in any calendar app.
- [ ] **ICS feed in.** Subscribe to any calendar URL and treat its events as busy.
- [ ] **Google Calendar two-way sync.** Read busy times from chosen calendars; write bookings and holds to a dedicated calendar.
- [ ] **Microsoft Outlook and Microsoft 365 two-way sync.**
- [ ] **Apple iCloud Calendar sync** through CalDAV.
- [ ] **Generic CalDAV** for Fastmail, Nextcloud and self-hosted servers.
- [ ] **Busy rules.** Choose which calendars block a day, how much of a day counts as blocked, and how to treat all-day events.
- [ ] **Conflict alerts** when an outside calendar event lands on a booked or held date.

### Apple Calendar first-class

Many performers live on an iPhone, so Apple Calendar can't be an afterthought behind Google.

- [ ] **One-tap subscribe on iPhone** to the bookings and holds feed.
- [ ] **Two-way iCloud sync** through CalDAV with app-specific passwords, tested on iOS, iPadOS and macOS.
- [ ] **Holds shown distinctly** in Apple Calendar (tentative status, separate calendar or color) so they never look like confirmed gigs.
- [ ] **Apple Shortcuts actions** for copy openings, mark a date, place a hold and check a date.

### Open source and self-hosted calendars

- [ ] **Booking Fire as a CalDAV server**, so any standards-based client (Apple Calendar, Thunderbird, GNOME Calendar, Evolution, DAVx⁵ on Android) can subscribe or sync directly.
- [ ] **Sync with self-hosted servers** such as Nextcloud, Radicale and Baïkal.
- [ ] **Standards conformance.** Follow the iCalendar (RFC 5545) and CalDAV (RFC 4791) specs closely, including time zones, recurrence and tentative events, and test against several clients.

## Open data and personal systems

Some people run their whole working life from their own tools: plain text notes, Emacs and Org mode, Markdown folders, scripts, home servers. Booking Fire should fit into those setups, not compete with them.

- [ ] **Full export at any time** in iCalendar, JSON, CSV and Markdown, with a matching import so data can come back in.
- [ ] **Documented REST API** covering everything the app can do, with personal tokens and scoped permissions.
- [ ] **Webhooks** for every change (hold placed, hold expiring, booked, released), so outside systems can react in real time.
- [ ] **Command-line client** for checking dates, placing holds and printing openings from a terminal or script.
- [ ] **Plain text openings everywhere.** Every template available at a stable URL as text, JSON or iCalendar.
- [ ] **Org mode and Markdown output** so bookings can flow into note-based systems and agendas.
- [ ] **Self-hosting guide.** Since the code is open source, document running your own instance with Docker or Kamal, including backups and upgrades.
- [ ] **No lock-in.** Nothing in the hosted service should require data to stay there.

## Phase 3: Sharing beyond copy and paste

Copy and paste stays the default, but some buyers and some performers want more.

- [ ] **Private read-only availability page** with a link that can be turned off at any time.
- [ ] **Per-recipient links** that show only what that venue or agent should see.
- [ ] **Embeddable widget** for performer websites (WordPress, Squarespace, Wix, Bandzoogle and plain HTML).
- [ ] **Link-in-bio page** with upcoming open dates and a contact button.
- [ ] **Image export** of the month for Instagram stories and posts.
- [ ] **"Request this date" button** on shared pages that creates an inquiry and a pending hold, without making the buyer book a time slot.

## Phase 4: Inquiries and pipeline

Once availability is fast, the next pain is tracking every conversation it starts.

- [ ] **Inquiry inbox.** Each request with who, which dates, event type, budget and source.
- [ ] **Forward-to-Booking-Fire email address** that turns inquiry emails into draft inquiries.
- [ ] **Contacts for venues, planners, agents and clients** with their history: past dates, rates, notes, who to call.
- [ ] **Pipeline stages.** Inquiry, quoted, on hold, contracted, deposit paid, played, paid in full.
- [ ] **Follow-up reminders** for unanswered quotes and expiring holds.
- [ ] **Response time tracking**, since speed of reply often decides who gets the gig.
- [ ] **Repeat-business nudges.** "You played the Blue Room every March. Reach out about next year?"
- [ ] **Season view.** How booked each month and weekend is, compared with last year.

## Phase 5: Bands, ensembles and teams

The hardest scheduling problem in music is finding a date when everyone is free.

- [ ] **Band workspaces.** A shared calendar where each member's availability rolls up.
- [ ] **Band openings message.** Dates when every required member is free, or when the lineup can be covered with subs.
- [ ] **Member roles.** Required, optional, and sub-able chairs.
- [ ] **Sub lists.** Ask a short list of trusted players if they can cover a date and track who said yes.
- [ ] **Hold requests to members** before confirming a date with a buyer.
- [ ] **Multiple projects per person.** One player in three bands sees every commitment in one calendar and never double-books across them.
- [ ] **Agent and manager access** with permission to place holds but not confirm bookings.
- [ ] **Speaker teams.** Assistants and bureaus who manage a speaker's calendar.

## Phase 6: Money and paperwork

Every booking ends in a contract and an invoice. Keeping them next to the date saves real time.

- [ ] **Rates per gig type** with travel and overtime add-ons, used in quotes.
- [ ] **Quotes** generated from a booking and sent as plain text or PDF.
- [ ] **Simple contracts** from editable templates, with e-signature.
- [ ] **Deposits and balances** tracked against each booking.
- [ ] **Payment links** for Stripe, PayPal, Venmo, Square and Cash App.
- [ ] **Invoices** with payment status and reminders.
- [ ] **Accounting export** to QuickBooks, Xero and Wave, plus CSV.
- [ ] **Band payouts.** Split a gig fee among members and subs.
- [ ] **Year-end summary** of income, gigs played and miles driven.

## Phase 7: Travel and routing

Distance changes which dates are really open.

- [ ] **Locations on bookings and holds.**
- [ ] **Travel buffers.** Block travel days automatically around out-of-town bookings.
- [ ] **Drive time checks.** Warn when two bookings on the same day or back-to-back days can't both be reached.
- [ ] **Routing suggestions.** "You're in Austin on the 14th. These nearby venues have booked you before."
- [ ] **Mileage log** for taxes, built from booked locations.
- [ ] **Travel itinerary import** from airline and hotel confirmation emails.

## Phase 8: Speaker-specific features

- [ ] **Session formats.** Keynote, workshop, panel, virtual, with default lengths and prep time.
- [ ] **Prep and travel blocks** that hold time before and after each engagement.
- [ ] **Virtual versus in-person availability**, since a speaker may be open for a webinar on a day they can't travel.
- [ ] **Speaker one-sheet attachment** with the openings message.
- [ ] **Call-for-proposals deadlines** tracked alongside bookings.

## Integrations

Integrations are the biggest opportunity. A working performer's booking life is spread across a dozen apps, and none of them talk to each other. Each candidate below needs its API access, terms and pricing confirmed before work starts.

### Calendars

| Integration | What it does |
| --- | --- |
| Apple Calendar (iCloud) | Two-way sync through CalDAV, one-tap subscribe on iPhone |
| Google Calendar | Two-way sync of busy times, bookings and holds |
| Microsoft Outlook / 365 | Two-way sync through Microsoft Graph |
| Any CalDAV server | Fastmail, Nextcloud, Radicale, Baïkal and other self-hosted servers |
| Open-source clients | Thunderbird, GNOME Calendar, Evolution, DAVx⁵ on Android |
| ICS feeds | Universal subscribe in and publish out |

### Open source and personal systems

| Integration | What it does |
| --- | --- |
| Emacs and Org mode | Bookings and holds as Org agenda entries; openings from a keystroke |
| Markdown and plain text folders | Export or sync bookings into note-based systems |
| Command-line client | Script dates, holds and openings from a terminal |
| Home automation and self-hosted tools (Home Assistant, n8n) | React to booking events on your own servers |

### Gig marketplaces and booking platforms

| Integration | What it does |
| --- | --- |
| GigSalad, The Bash | Bring in leads and keep availability current, where the platform allows |
| Bandsintown, Songkick | Publish confirmed public shows to fan-facing listings |
| Gigwell, Prism.fm | Exchange holds and confirmations with agencies and venues that use them |
| BandHelper | Sync gigs with a tool many bands already use for setlists and member scheduling |
| Speaker bureaus and platforms such as eSpeakers and SpeakerHub | Keep speaker availability current |

### Messaging and sharing

| Integration | What it does |
| --- | --- |
| Web Share and the mobile share sheet | Send the message into any messaging app |
| Email | Send openings and replies directly, and receive forwarded inquiries |
| SMS | Text openings and hold reminders where carriers and cost allow |
| WhatsApp | Share messages and receive inquiries through the WhatsApp Business platform |
| Slack and Discord | Band channel bot: `/openings`, hold requests, "who's free on the 20th?" |

### Automation and shortcuts

| Integration | What it does |
| --- | --- |
| Public API and webhooks | Every event (hold placed, hold expiring, booked) available to other tools |
| Zapier, Make, n8n | No-code connections to anything else |
| Apple Shortcuts and Siri | "Hey Siri, copy my openings" and voice entry of bookings |
| Text expanders (TextExpander, Espanso, Raycast) | Type a shortcut anywhere to paste current openings |
| Browser extension | Insert openings into Gmail, Facebook, Instagram and marketplace inboxes |

### Money and documents

| Integration | What it does |
| --- | --- |
| Stripe, Square, PayPal | Deposits and balance payments |
| Venmo, Cash App | Payment links in messages |
| QuickBooks, Xero, Wave | Income and invoice export |
| Dropbox Sign, DocuSign | Contract signatures |
| Google Drive, Dropbox | Store contracts, riders and stage plots with the booking |

### Maps and travel

| Integration | What it does |
| --- | --- |
| Google Maps, Apple Maps | Drive time checks and routing suggestions |
| TripIt and email itinerary parsing | Bring flights and hotels into travel blocks |

### Websites

| Integration | What it does |
| --- | --- |
| WordPress plugin | Availability widget and inquiry form |
| Squarespace, Wix, Bandzoogle | Embeddable widget |
| Link-in-bio tools | Upcoming open dates on a performer's profile |

## Platform and quality

- [ ] **Native mobile apps** once the PWA hits its limits (widgets, share extensions, notifications).
- [ ] **Push notifications** for expiring holds, new inquiries and calendar conflicts.
- [ ] **Accessibility.** Full keyboard use, screen reader labels and color choices that don't rely on red and green alone.
- [ ] **Privacy controls.** Clear choices about what shared links and integrations can see, and client names never shown on public pages.
- [ ] **Security.** Two-factor sign-in, session management, and audit of connected integrations.
- [ ] **Performance.** Calendar and message stay instant with years of bookings.
- [ ] **Imports** from spreadsheets and other booking tools.

## Not planned

- **Time-slot booking pages in the style of Calendly.** The point is that the buyer doesn't have to click anything.
- **Ticketing.** Plenty of good tools already sell tickets.
- **A general-purpose CRM.** Contacts and pipeline stay focused on booking dates.

## Open questions

- Should band calendars be a separate workspace or a view across members' personal calendars?
- How much of the inquiry inbox belongs inside Booking Fire versus synced to tools people already use?
- Which marketplace platforms offer APIs that allow availability sync, and on what terms?
- Where is the line between a free plan and a paid one?

## Contributing ideas

Ideas from working musicians and speakers shape this list. Open an issue describing the situation you were in, what you had to do by hand, and what you wish had happened instead.
