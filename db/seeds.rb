puts "Καθαρίζω τη βάση..."
Noticed::Notification.destroy_all
Noticed::Event.destroy_all
Message.destroy_all
ConversationUser.destroy_all
Conversation.destroy_all
Membership.destroy_all
Group.destroy_all
Contact.destroy_all
PostCategory.destroy_all
Post.destroy_all
Category.destroy_all
UserInterest.destroy_all
Interest.destroy_all
Enrollment.destroy_all
Course.destroy_all
User.destroy_all

puts "Δημιουργώ μαθήματα..."
cs101 = Course.create!(code: "CS101", title: "Εισαγωγή στον Προγραμματισμό")
cs205 = Course.create!(code: "CS205", title: "Βάσεις Δεδομένων")
cs310 = Course.create!(code: "CS310", title: "Λειτουργικά Συστήματα")

puts "Δημιουργώ ενδιαφέροντα..."
ml = Interest.create!(name: "Machine Learning")
web = Interest.create!(name: "Web Development")
security = Interest.create!(name: "Κυβερνοασφάλεια")

puts "Δημιουργώ κατηγορίες..."
announcements = Category.create!(name: "Ανακοινώσεις")
questions = Category.create!(name: "Ερωτήσεις")
material = Category.create!(name: "Υλικό μαθήματος")

puts "Δημιουργώ χρήστες..."
maria = User.create!(name: "Maria Papadopoulou", email: "maria@example.com", password: "secret123", bio: "3ο έτος, ενδιαφέρομαι για web development")
giannis = User.create!(name: "Giannis Nikolaou", email: "giannis@example.com", password: "secret456", bio: "2ο έτος, machine learning enthusiast")
eleni = User.create!(name: "Eleni Konstantinou", email: "eleni@example.com", password: "secret789", bio: "4ο έτος, κυβερνοασφάλεια")

Enrollment.create!(user: maria, course: cs101)
Enrollment.create!(user: maria, course: cs205)
Enrollment.create!(user: giannis, course: cs101)
Enrollment.create!(user: giannis, course: cs310)
Enrollment.create!(user: eleni, course: cs205)
Enrollment.create!(user: eleni, course: cs310)

UserInterest.create!(user: maria, interest: web)
UserInterest.create!(user: giannis, interest: ml)
UserInterest.create!(user: eleni, interest: security)
UserInterest.create!(user: eleni, interest: web)

puts "Δημιουργώ posts..."
post1 = Post.create!(user: maria, title: "Βοήθεια με το Rails routing", body: "Κάποιος να εξηγήσει τη διαφορά nested vs shallow routes;")
post1.categories << questions

post2 = Post.create!(user: giannis, title: "Σημειώσεις CS310 - Κεφάλαιο 3", body: "Ανέβασα τις σημειώσεις μου για scheduling algorithms.")
post2.categories << material

post3 = Post.create!(user: eleni, title: "Αναβολή παράδοσης εργασίας", body: "Ο καθηγητής ανακοίνωσε παράταση μέχρι την Παρασκευή.")
post3.categories << announcements

puts "Δημιουργώ επαφές..."
Contact.create!(requester: maria, recipient: giannis, status: "accepted")
Contact.create!(requester: eleni, recipient: maria, status: "pending")

puts "Δημιουργώ ομάδα..."
group = Group.create!(name: "Ομάδα Εργασίας Rails", description: "Συνεργασία για την τελική εργασία", owner: maria)
Membership.create!(group: group, user: maria, role: "owner")
Membership.create!(group: group, user: giannis, role: "member")

conversation = group.conversations.create!
ConversationUser.create!(conversation: conversation, user: maria)
ConversationUser.create!(conversation: conversation, user: giannis)
Message.create!(conversation: conversation, user: maria, body: "Καλησπέρα, ξεκινάμε το setup;")

puts "-" * 40
puts "Users: #{User.count}, Courses: #{Course.count}, Posts: #{Post.count}"
puts "Groups: #{Group.count}, Conversations: #{Conversation.count}, Messages: #{Message.count}"
puts "Login: maria@example.com / secret123"
puts "Login: giannis@example.com / secret456"
puts "Login: eleni@example.com / secret789"