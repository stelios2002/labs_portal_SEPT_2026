# Labs Portal — Σημειώσεις Προόδου

Working notes, όχι τελική τεκμηρίωση — ενημερώνεται.

## Τεχνολογίες

- Ruby on Rails 8.1 (πλήρες, με views — όχι API-only, σε αντίθεση με το Θέμα 2)
- PostgreSQL
- Devise — authentication με email/password
- omniauth-google-oauth2, omniauth-facebook, omniauth-rails_csrf_protection — social login
- Active Storage — avatar upload
- pg_search, noticed — έρχονται σε επόμενα Parts (αναζήτηση posts, notifications)

## Εγκατάσταση (τοπικά, Windows)

```bash
git clone https://github.com/stelios2002/labs_portal_SEPT_2026
cd labs_portal
bundle install
```

Χρειάζεται τοπικός PostgreSQL server με χρήστη `postgres` (δες `config/database.yml` — password μπαίνει εκεί).

```bash
rails db:create
rails db:migrate
rails server
```

Server στο `http://localhost:3000`.

### Google / Facebook OAuth — για development

Χρειάζονται credentials (δεν είναι στο repo, είναι κρυπτογραφημένα στο `config/credentials.yml.enc` + `config/master.key` — το δεύτερο ΔΕΝ ανεβαίνει ποτέ στο git):

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

## Μοντέλα μέχρι στιγμής

- **User** (Devise) — name, email, encrypted_password, provider, uid, am, bio, avatar (Active Storage)
- **Course** — code, title
- **Enrollment** — join table User↔Course
- **Interest** — name
- **UserInterest** — join table User↔Interest
- **Category** — name (διαχειρίζεται από admin namespace)

Το πλήρες σχέδιο (και τα μοντέλα που έρχονται: Post, PostCategory, Contact, Group, Membership, Conversation, ConversationUser, Message)

## Δύο ξεχωριστοί μηχανισμοί authentication (σκόπιμο, το ζητά η εκφώνηση)

1. **Devise** (session-based) — για κανονικούς χρήστες, με email/password ή Google/Facebook OAuth
2. **HTTP Basic Auth** (stateless) — μόνο για το `/admin` namespace, εντελώς ανεξάρτητο από το Devise

## Επόμενα βήματα

Posts: μοντέλο, CRUD, βασικές σελίδες.
