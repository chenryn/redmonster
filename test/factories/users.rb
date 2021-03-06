# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:nickname) { |n| "Monster_#{n}" }
    sequence(:email) { |n| "monster_#{n}@monster.com" }
    password ENV['RABEL_TEST_DEFAULT_PASSWORD']
    password_confirmation ENV['RABEL_TEST_DEFAULT_PASSWORD']
    after(:create) {|u| u.account = FactoryGirl.create(:account, :user => u)}

    factory :admin do
      role 'admin'
    end

    factory :root do
      role 'root'
    end
  end
end
