User.create!(name: "user1",
             email: "user1@example.com",
             password: "password")

10.times do |n|
name  = "user#{n+2}"
email = "user#{n+2}@example.com"
password = "password"
User.create!(name:  name,
             email: email,
             password: password)
end

Task.create!(name:  "task1",
             detail: "task1 is ...",
             deadline: Time.current + 1.days,
             status: 2,
             priority: 2,
             user_id: 1)

99.times do |n|
name  = "task#{n+2}"
detail = "task#{n+2} is ..."
deadline = Time.current + (n+2).days
a = (0..32).map{|i| 1+3*i }
b = (0..32).map{|i| 2+3*i }
if a.include?(n+2)
  status = 2
  priority = 2
  user_id = 1
elsif b.include?(n+2)
  status = 1
  priority = 1
  user_id = 2
else
  status = 0
  priority = 0
  user_id = 3
end
Task.create!(name:  name,
             detail: detail,
             deadline: deadline,
             status: status,
             priority: priority,
             user_id: user_id)
end