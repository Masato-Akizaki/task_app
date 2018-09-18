require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  describe "新規タスク" do
    before do
      login_user1
      visit root_path
      click_link "新規タスクを追加"  
    end

    it "新規タスク作成画面が表示される" do 
      expect(page.current_path).to eq new_task_path
    end

    it "タスクを新規作成できる" do
      fill_in "タスク名",   with: "task1"
      fill_in "詳細", with: "task1 is ..."
      fill_in "期限日", with: "2018/08/31"
      select "着手中", from: "ステータス"
      select "高", from: "優先度"
      click_button "保存"

      expect(page).to have_content "タスクを登録しました"
      expect(page).to have_content "task1"
      expect(page).to have_content "task1 is ..."
      expect(page).to have_content "2018-08-31"
      expect(page).to have_content "着手中"
      expect(page).to have_content "高"


      task = Task.last
      expect(task.name).to eq "task1"
      expect(task.detail).to eq "task1 is ..."
      expect(task.deadline).to have_content "2018-08-31"
      expect(task.status_i18n).to have_content "着手中"
      expect(task.priority_i18n).to have_content "高"

    end
  end

  describe "タスク詳細・編集・更新" do
    before do
      login_user1
      Task.create!(id: 1, name: 'task1', detail: 'task1 is ...', user_id: 1)
      visit root_path
      click_link "task1" 
    end

    it "タスク詳細画面が表示される" do
      expect(page.current_path).to eq task_path(1)
      expect(page).to have_content "task1"
      expect(page).to have_content "task1 is ..."
      expect(page).to have_content "編集"
      expect(page).to have_content "削除"
    end

    it "タスク編集画面が表示される" do
      click_link "編集"
      expect(page.current_path).to eq edit_task_path(1)
    end
      
    it "タスクを更新できる" do
      click_link "編集"
      fill_in "タスク名",   with: "task1-1"
      fill_in "詳細", with: "task1-1 is ..."
      fill_in "期限日", with: "2018/08/31"
      select "着手中", from: "ステータス"
      select "高", from: "優先度"
      click_button "保存"

      expect(page).to have_content "タスクを更新しました"
      expect(page).to have_content "task1-1"
      expect(page).to have_content "task1-1 is ..."
      expect(page).to have_content "2018-08-31"
      expect(page).to have_content "着手中"
      expect(page).to have_content "高"


      task = Task.find(1)
      expect(task.name).to eq "task1-1"
      expect(task.detail).to eq "task1-1 is ..."
      expect(task.deadline).to have_content "2018-08-31"
      expect(task.status_i18n).to have_content "着手中"
      expect(task.priority_i18n).to have_content "高"

    end

    it "タスクを削除できる" do
      visit task_path(1)
      click_link "削除"
    
      expect(page.current_path).to eq root_path
      expect(page).to have_content "タスクを削除しました"

      expect(Task.find_by(id: 1)).to eq nil
    end
  end

  describe "タスク一覧の表示順" do
    before do
      login_user1
      Task.create(id: 1, name: "task1", created_at: Time.current + 1.hours, deadline: Time.current + 1.month, user_id: 1)
      Task.create(id: 2, name: "task2", created_at: Time.current + 2.hours, deadline: Time.current + 3.month, user_id: 1)
      Task.create(id: 3, name: "task3", created_at: Time.current + 3.hours, deadline: Time.current + 2.month, user_id: 1)
      Task.create(id: 4, name: "task4", created_at: Time.current + 4.hours, deadline: Time.current + 4.month, user_id: 1)
      visit root_path
    end

    it 'デフォルトがcreated_at降順で表示' do
      within '.tasks' do
        task_ids = all('.task-id').map(&:text)
        expect(task_ids).to eq %w(4 3 2 1)
      end
    end

    it "created_at昇順で並び替え" do
      click_link "作成順"
      within '.tasks' do
        task_ids = all('.task-id').map(&:text)
        expect(task_ids).to eq %w(1 2 3 4)
      end
    end

    it "deadline昇順で並び替え" do
      click_link "期限順"
      within '.tasks' do
        task_ids = all('.task-id').map(&:text)
        expect(task_ids).to eq %w(1 3 2 4)
      end
    end

    it "deadline降順で並び替え" do
      click_link "期限順"
      click_link "期限順"
      within '.tasks' do
        task_ids = all('.task-id').map(&:text)
        expect(task_ids).to eq %w(4 2 3 1)
      end
    end
  end

  describe "タスクを検索" do
    before do
      login_user1
      Task.create(id: 1, name: "task1", status: "completed", user_id: 1)
      Task.create(id: 2, name: "task2", status: "waiting", user_id: 1)
      Task.create(id: 3, name: "work3", status: "waiting", user_id: 1)
      visit root_path
    end

    context "一致するタスク名が見つかるとき" do
      it "検索文字列に一致するタスクを返す" do
        fill_in "タスク名",   with: "task1"
        click_button "検索"
        expect(page).to have_content "task1"
        expect(page).to_not have_content "task2"
        expect(page).to_not have_content "work3"
      end
    end

    context "一致するステータスが見つかるとき" do
      it "選択ステータスに一致するタスクを返す" do
        select "未着手", from: "ステータス"
        click_button "検索"
        expect(page).to_not have_content "task1"
        expect(page).to have_content "task2"
        expect(page).to have_content "work3"
      end
    end

    context "一致するタスク名とステータスが見つかるとき" do
      it "検索文字列と選択ステータスに一致するタスクを返す" do
        fill_in "タスク名",   with: "task"
        select "未着手", from: "ステータス"
        click_button "検索"
        expect(page).to_not have_content "task1"
        expect(page).to have_content "task2"
        expect(page).to_not have_content "work3"
      end
    end

    context "一致するタスク名とステータスが見つからないとき" do
      it "空のコレクションを返す" do
        fill_in "タスク名",   with: "task4"
        select "着手中", from: "ステータス"
        click_button "検索"
        expect(page).to_not have_content "task1"
        expect(page).to_not have_content "task2"
        expect(page).to_not have_content "work3"
      end
    end
  end
end