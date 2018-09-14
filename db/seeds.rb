User.create!(name: "user1",
             email: "user1@example.com")

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
elsif b.include?(n+2)
  status = 1
  priority = 1
else
  status = 0
  priority = 0
end
Task.create!(name:  name,
             detail: detail,
             deadline: deadline,
             status: status,
             priority: priority,
             user_id: 1)
end