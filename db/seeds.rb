User.create!(name: "user1",
             email: "user1@example.com"
             password: "password")

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
elsif b.include?(n+2)
  status = "着手中"
  priority = "中"
else
  status = "未着手"
  priority = "低"
end
Task.create!(name:  name,
             detail: detail,
             deadline: deadline,
             status: status,
             priority: priority,
             user_id: 1)
end