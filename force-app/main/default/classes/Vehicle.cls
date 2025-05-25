public abstract class Vehicle implements Rentable {
    private String brand;
    private String model;
    private Decimal baseRate;

    public Vehicle(String brand, String model, Decimal baseRate) {
        this.brand = brand;
        this.model = model;
        this.baseRate = baseRate;
    }

    // Encapsulation using getters
    public String getBrand() { return this.brand; }
    public String getModel() { return this.model; }
    public Decimal getBaseRate() { return this.baseRate; }

    // Abstract method for child classes to define
    public abstract void start();

    // Interface method implemented here
    public virtual Decimal calculateRentalCost(Integer days) {
        return this.baseRate * days;
    }

    public virtual void showDetails() {
        System.debug('Brand: ' + brand + ', Model: ' + model + ', Base Rate: $' + baseRate);
    }
}
