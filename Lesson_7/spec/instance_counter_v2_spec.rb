require 'instance_counter_v2'

describe InstanceCounter do
  context "При подмешивании модуля в класс" do
    before(:each) do
      class B
        include InstanceCounter
        def initialize
          register_instance
        end
      end
    end
    it "должен появится метод класса instance" do
      expect(B).to respond_to(:instance)
    end
    it "должно подсчитываться кол-во экземпляров класса" do
      amount = 10
      amount.times { B.new }  
      expect(B.instance).to eql(amount)
    end
  end

end
