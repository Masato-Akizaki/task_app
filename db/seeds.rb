User.create!(name: "user1",
             email: "user1@example.com",
             password: "password",
             admin: true)

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
             status: "完了",
             priority: "高",
             user_id: 1)

99.times do |n|
name  = "task#{n+2}"
detail = "task#{n+2} is ..."
deadline = Time.current + (n+2).days
a = (0..32).map{|i| 1+3*i }
b = (0..32).map{|i| 2+3*i }
if a.include?(n+2)
  status = "完了"
  priority = "高"
  user_id = 1
elsif b.include?(n+2)
  status = "着手中"
  priority = "中"
  user_id = 2
else
  status = "未着手"
  priority = "低"
  user_id = 3
end
Task.create!(name:  name,
             detail: detail,
             deadline: deadline,
             status: status,
             priority: priority,
             user_id: user_id)
end