# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadElectricityPlansService do
  describe '#call' do
    context '電力会社のプランデータがあり、1つの電力会社に0、1つ、複数のプランがそれぞれ登録されているとき' do
      it 'プランを持たない電力会社のデータは含めずに、電力会社のプランをElectricityPlanの配列で返す' do
        plans = described_class.new.call('spec/fixtures/test_electricity_plans.yml')
        expect(plans).to all(be_an_instance_of(ElectricityPlan))
        expect(plans.size).to eq 3
        expect(plans.map(&:provider).map(&:name)).to eq %w[電力会社A 電力会社A 電力会社B]
      end
    end

    context 'プランを持たない電力会社のみがあるとき' do
      it '空の配列を返す' do
        plans = described_class.new.call('spec/fixtures/test_electricity_provider_without_plan.yml')
        expect(plans).to eq []
      end
    end

    context 'データが空のとき' do
      it 'ファイルが空ですという例外を発生させる' do
        expect do
          described_class.new.call('spec/fixtures/empty.yml')
        end.to raise_error('ファイルが空です: spec/fixtures/empty.yml')
      end
    end

    context 'ファイルが存在しないとき' do
      it 'ファイルが存在しませんという例外を発生させる' do
        expect do
          described_class.new.call('spec/fixtures/not_exist.yml')
        end.to raise_error('ファイルが存在しません: spec/fixtures/not_exist.yml')
      end
    end
  end
end
