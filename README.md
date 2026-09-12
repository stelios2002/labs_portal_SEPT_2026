# Labs Portal — Σημειώσεις Προόδου

Portal εργαστηριακών ασκήσεων (Θέμα 1). Working notes, όχι τελική τεκμηρίωση — ενημερώνεται σε κάθε Part.

## Στοιχεία εργασίας

- Φοιτητής: Στυλιανός Κωνσταντίνος Βαρυμπομπιώτης — Π20028
- Ακαδημαϊκό έτος 2025-2026

## Τεχνολογίες

- Ruby on Rails 8.1 (πλήρες, με views — όχι API-only, σε αντίθεση με το Θέμα 2)
- PostgreSQL
- Devise — authentication με email/password
- omniauth-google-oauth2, omniauth-facebook, omniauth-rails_csrf_protection — social login
- Active Storage — avatar upload
- pg_search — full-text αναζήτηση posts (PostgreSQL `tsearch`)
- Redis (μέσω Memurai σε Windows) + ActionCable — real-time chat
- noticed (v3) — notifications, με delivery μέσω ActionCable
- Hotwire (Turbo Streams + Stimulus) — real-time UI χωρίς custom JS σε κάθε σημείο

## Εγκατάσταση

```bash
git clone https://github.com/stelios2002/labs_portal_SEPT_2026
cd labs_portal
bundle install
```

Χρειάζεται τοπικός PostgreSQL server με χρήστη `postgres` (δες `config/database.yml` — password μπαίνει εκεί).

```bash
rails db:create
rails db:migrate
rails db:seed
rails server
```

Server στο `http://localhost:3000`. Demo χρήστες (από τα seeds):

| Email | Password |
|---|---|
| maria@example.com | secret123 |
| giannis@example.com | secret456 |
| eleni@example.com | secret789 |

### Redis / ActionCable

Windows δεν έχει επίσημο Redis build — χρησιμοποιούμε **Memurai** (Redis-συμβατό, native Windows): [memurai.com/get-memurai](https://memurai.com/get-memurai), Developer edition. Τρέχει ως Windows service αυτόματα στο port 6379. Επιβεβαίωση: `redis-cli ping` → `PONG`.

### Google / Facebook OAuth — για development

Χρειάζονται δικά σου credentials (δεν είναι στο repo, είναι κρυπτογραφημένα στο `config/credentials.yml.enc` + `config/master.key` — το δεύτερο ΔΕΝ ανεβαίνει ποτέ στο git):

```bash
set EDITOR=code --wait
rails credentials:edit
```

Δομή που περιμένει ο κώδικας:

```yaml
google:
  client_id: ...
  client_secret: ...
facebook:
  app_id: ...
  app_secret: ...
admin:
  username: ...
  password: ...
```

Redirect URIs που πρέπει να δηλωθούν στα αντίστοιχα developer consoles:
- Google: `http://localhost:3000/users/auth/google_oauth2/callback`
- Facebook: `http://localhost:3000/users/auth/facebook/callback`

## Μοντέλα

- **User** (Devise) — name, email, encrypted_password, provider, uid, am, bio, avatar (Active Storage)
- **Course** — code, title
- **Enrollment** — join table User↔Course
- **Interest** — name
- **UserInterest** — join table User↔Interest
- **Category** — name (διαχειρίζεται από admin namespace)
- **Post** — title, body· pg_search πάνω σε title/body· σχέση με Category μέσω PostCategory
- **PostCategory** — join table Post↔Category
- **Contact** — requester/recipient (και τα δύο User), status (pending/accepted/rejected) — αίτημα με αποδοχή, όχι αυτόματα αμφίδρομο
- **Group** — name, description, owner (User)· ανεξάρτητο από Course
- **Membership** — join table Group↔User, με role (owner/member)
- **Conversation** — προαιρετικό group_id (null = 1-προς-1, γεμάτο = ομαδικό chat)
- **ConversationUser** — join table Conversation↔User
- **Message** — conversation, user, body· broadcast μέσω Turbo Stream + notifier σε κάθε νέο μήνυμα
- **Noticed::Event / Noticed::Notification** — διαχειρίζονται πλήρως από το gem `noticed`, όχι δικά μας μοντέλα

## Δύο ξεχωριστοί μηχανισμοί authentication

1. **Devise** (session-based) — για κανονικούς χρήστες, με email/password ή Google/Facebook OAuth
2. **HTTP Basic Auth** (stateless) — μόνο για το `/admin` namespace, εντελώς ανεξάρτητο από το Devise

## Real-time κομμάτια

- **Chat**: `ConversationChannel`, ένα stream ανά συνομιλία (`conversation_#{id}`), broadcast μέσω `broadcast_append_to` (Turbo Stream, HTML fragment — όχι raw JSON)
- **Notifications**: `NotificationsChannel`, ένα stream ανά χρήστη (`stream_for current_user`), ενεργοποιείται από `NewMessageNotifier` (noticed) σε κάθε νέο μήνυμα, εκτός του ίδιου του αποστολέα
- Και τα δύο περνούν από authentication μέσω `env["warden"].user` στο `ApplicationCable::Connection` — το Devise session, όχι JWT (διαφορετικό μοντέλο από το Θέμα 2)

## Fixes μετά το πρώτο πέρασμα screenshots/QA

- Devise signup: προστέθηκε πεδίο Name (view + strong parameters)
- Root route (`root to: "posts#index"`) — έλειπε εντελώς
- Contact: validation αμφίδρομης μοναδικότητας (requester↔recipient και οι δύο κατευθύνσεις)
- Profile routes: custom routes με προαιρετικό `:id` (το `resource :profile` δεν υποστήριζε προβολή άλλου χρήστη)
- noticed v3 API: `deliver_by :action_cable` χρειάζεται ρητό `config.message`
- Chat popup: πλήρης επανασχεδίαση με `data-turbo-frame` (Turbo Frame src) αντί για static persistent container
- Time zone: δυναμικό μέσω cookie (`Intl.DateTimeFormat` στο browser + `around_action` στον `ApplicationController`), αντί για hardcoded ζώνη
- Admin namespace: διόρθωση ώστε το nav να μη δείχνει Devise session links (χρήση `@admin_context` flag)