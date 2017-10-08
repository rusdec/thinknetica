require 'berzerker'

describe Berzerker do

  describe "Создание" do

    before(:each) do
      @unit = Berzerker.new
    end

    context "Уровень по-умолчанию" do
      it "должен быть равен 1" do
        expect(@unit.get_level).to eql(1)
      end
    end

    context "Опыт по-умолчанию" do
      it "Минимальный должен быть равен 0" do
        expect(@unit.get_experience_min).to eql(0)
      end
      it "Максимальный должен быть равен 100" do
        expect(@unit.get_experience_max).to eql(100)
      end
      it "Текущий должен быть равен минимальному и равен 0" do
        expect(@unit.get_experience).to eql(0)
        expect(@unit.get_experience_min).to eql(0)
      end
    end

    context "Параметры по-умолчанию" do
      it "Урон должен быть равен 2" do
        expect(@unit.damage).to eq(2)
      end
      it "Радиус должен быть равен 2" do
        expect(@unit.radius).to eq(2)
      end
      it "Скорость должна быть равна 2" do
        expect(@unit.speed).to eq(2)
      end
      it "Площадь поражения должна быть равна 1" do
        expect(@unit.area).to eq(1)
      end
      it "Стоимость должна быть равна 100" do
        expect(@unit.cost).to eq(100)
      end
      context "КоэФфициент" do
        it "урона должен быть равен 0.2" do
          expect(@unit.get_coefficient 'damage').to eql(0.2)
        end
        it "скорости должен быть равен 0.2" do
          expect(@unit.get_coefficient 'speed').to eql(0.2)
        end
        it "площади должен быть равен 0" do
          expect(@unit.get_coefficient 'area').to eql(0)
        end
        it "радиуса должен быть равен 0.1" do
          expect(@unit.get_coefficient 'radius').to eql(0.1)
        end
      end
    end #context "Параметры по-умолчанию"

  end
  
  describe "Повышение уровня" do
    before(:each) do
      @unit = Berzerker.new
    end

    context "Опыт" do
      it "Текущий опыт может увеличиваться" do
        exp = 10
        experience_old = @unit.get_experience
        @unit.add_experience(exp)
        expect(@unit.get_experience).to eql(experience_old + exp)
      end
      context "Если текущий опыт больше максимального" do
        it "Уровень должен увеличиться на 1" do
          level_old = @unit.get_level
          exp = @unit.get_experience_max + 10
          @unit.add_experience(exp)
          expect(@unit.get_level).to eq(level_old + 1)
        end 
        it "Максимальный опыт должен увеличиться на 25%" do
          experience_max_old = @unit.get_experience_max
          exp = @unit.get_experience_max + 10
          @unit.add_experience(exp)
          expect(@unit.get_experience_max).to eql(experience_max_old + (experience_max_old*0.25))
        end
        it "Минимальный опыт должен быть равен 0" do
          @unit.level_up
          expect(@unit.get_experience_min).to eql(0)
        end
        it "Текущий должен быть равен минимальному и равен 0" do
          @unit.add_experience(1000)
          expect(@unit.get_experience).to eql(0)
          expect(@unit.get_experience_min).to eql(0)
        end
      end
    end
    context "Параметры при повышении уровня" do
      it "Урон должен увеличиться на 20% от текущего" do
        damage_old = @unit.damage
        @unit.level_up
        expect(@unit.damage).to eql(damage_old+(damage_old*0.2))
      end
      it "Скорость должна увеличиться на 20% от текущего" do
        speed_old = @unit.speed
        @unit.level_up
        expect(@unit.speed).to eql(speed_old+(speed_old*0.2))
      end
      it "Площадь должна быть равной 1" do
        @unit.level_up
        expect(@unit.area).to eql(1)
      end
    end
  end #describe "Создание"

end
