public with sharing class Bike extends Vehicle{
    Boolean isGeared;

    public Bike(String brand, String model, Decimal baseRate, Boolean isGeared) {
        super(brand, model, baseRate);
        this.isGeared = isGeared;
    }

    public override void start() {
        System.debug('Bike ' + super.getBrand() + ' started with a kick');
    }

    public override void showDetails() {
        super.showDetails();
        System.debug('Bike Type: ' + (isGeared ? 'Geared':'Not Geared'));
    }
}