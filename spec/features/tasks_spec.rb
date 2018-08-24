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
    it "created_at降順で並び替える" do
      Task.create(id: 1, name: "task1", created_at: Time.current + 1.hours)
      Task.create(id: 2, name: "task2", created_at: Time.current + 2.hours)

      expect(Task.order("created_at DESC").map(&:id)).to eq [2,1]
    end
  end
end