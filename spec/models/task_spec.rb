require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validates" do
    it "エラーメッセージが格納されるか" do
      task = Task.new()
      task.valid?
      expect(task.errors.messages[:name]).to include "を入力してください"
    end
  end

  describe "search task" do
    before do
      @task1 = Task.create(id: 1, name: "task1", status: "完了")
      @task2 = Task.create(id: 2, name: "task2", status: "未着手")
      @task3 = Task.create(id: 3, name: "work3", status: "未着手")
    end

    context "一致するタスク名が見つかるとき" do
      it "検索文字列に一致するタスクを返す" do
        expect(Task.search("task1","")).to include(@task1)
        expect(Task.search("task1","")).to_not include(@task2, @task3)
      end
    end

    context "一致するステータスが見つかるとき" do
      it "選択ステータスに一致するタスクを返す" do
        expect(Task.search("","未着手")).to include(@task2, @task3)
        expect(Task.search("","未着手")).to_not include(@task1)
      end
    end

    context "一致するタスク名とステータスが見つかるとき" do
      it "検索文字列と選択ステータスに一致するタスクを返す" do
        expect(Task.search("task","未着手")).to include(@task2)
        expect(Task.search("task","未着手")).to_not include(@task1, @task3)
      end
    end

    context "一致するタスク名とステータスが見つからないとき" do
      it "空のコレクションを返す" do
      expect(Task.search("task4","着手中")).to be_empty
      end
    end
  end

end
