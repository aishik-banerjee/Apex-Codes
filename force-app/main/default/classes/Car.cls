public class Car extends Vehicle {
    private Boolean isAutomatic;

    public Car(String brand, String model, Decimal baseRate, Boolean isAutomatic){
        super(brand, model, baseRate);
        this.isAutomatic = isAutomatic;
    }
        

    public override void start() {
        System.debug('Car ' + super.getBrand() + ' started with key ignition.');
    }

    public override void showDetails() {
        super.showDetails();
        System.debug('Car Type: ' + (isAutomatic ? 'Automatic' : 'Manual'));
    }

    public override Decimal calculateRentalCost(Integer days) {
        Decimal rate = super.getBaseRate();
        if (isAutomatic) rate += 10;
        return rate * days;
    }
}
