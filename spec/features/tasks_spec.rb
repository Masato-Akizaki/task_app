require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  describe "新規タスク" do
    before do
      visit root_path      
      click_link "新規タスクを追加" 
    end

    it "新規タスク作成画面が表示される" do
      expect(page.current_path).to eq new_task_path
    end

    it "タスクを新規作成できる" do
      fill_in "タスク名",   with: "task1"
      fill_in "詳細", with: "task1 is ..."
      click_button "保存"

      expect(page).to have_content "タスクを登録しました"
      expect(page).to have_content "task1"
      expect(page).to have_content "task1 is ..."

      task = Task.last
      expect(task.name).to eq "task1"
      expect(task.detail).to eq "task1 is ..."
    end
  end

  describe "タスク詳細・編集・更新" do
    before do   
      Task.create!(id: 1, name: 'task1', detail: 'task1 is ...')
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
      click_button "保存"

      expect(page).to have_content "タスクを更新しました"
      expect(page).to have_content "task1-1"
      expect(page).to have_content "task1-1 is ..."

      task = Task.find(1)
      expect(task.name).to eq "task1-1"
      expect(task.detail).to eq "task1-1 is ..."
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
      Task.create(id: 1, name: "task1", created_at: Time.current + 1.hours, deadline: Time.current + 1.month)
      Task.create(id: 2, name: "task2", created_at: Time.current + 2.hours, deadline: Time.current + 3.month)
      Task.create(id: 3, name: "task3", created_at: Time.current + 3.hours, deadline: Time.current + 2.month)
      Task.create(id: 4, name: "task4", created_at: Time.current + 4.hours, deadline: Time.current + 4.month)
      visit root_path
    end

    it 'デフォルトがcreated_at降順で表示' do
      within '.tasks' do
        task_ids = all('.task-id').map(&:text)
        expect(task_ids).to eq %w(No.4 No.3 No.2 No.1)
      end
    end

    it "created_at昇順で並び替え" do
      click_link "作成順"
      within '.tasks' do
        task_ids = all('.task-id').map(&:text)
        expect(task_ids).to eq %w(No.1 No.2 No.3 No.4)
      end
    end

    it "deadline昇順で並び替え" do
      click_link "期限順"
      within '.tasks' do
        task_ids = all('.task-id').map(&:text)
        expect(task_ids).to eq %w(No.1 No.3 No.2 No.4)
      end
    end

    it "deadline降順で並び替え" do
      click_link "期限順"
      click_link "期限順"
      within '.tasks' do
        task_ids = all('.task-id').map(&:text)
        expect(task_ids).to eq %w(No.4 No.2 No.3 No.1)
      end
    end
  end
end