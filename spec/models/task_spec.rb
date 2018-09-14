require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validates" do
    it "エラーメッセージが格納されるか" do
      task = Task.new()
      task.valid?
      expect(task.errors.messages[:name]).to include "を入力してください"
    end
  end
end
