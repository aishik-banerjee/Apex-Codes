public with sharing class FlowApexTransfer {

    @InvocableMethod(label='Invocable Method Test' description='Returns the amount after discount')
    public static List<FlowResponse> calculateDiscount(List<FlowRequest> request){

        List<FlowResponse> flowResponseList = new List<FlowResponse>();
        for(FlowRequest req: request){
            FlowResponse flowResponse = new FlowResponse();
            flowResponse.amount = req.price - (req.price * (req.discountPercentage/100));
            flowResponseList.add(flowResponse);
        }

        return flowResponseList;

    }

    public class FlowRequest{
        @InvocableVariable(label='Price' description='Price to be discounted' required=true)
        public Decimal price;

        @InvocableVariable(label='Discount Percentage' description='Discount given' required=true)
        public Decimal discountPercentage;
    }

    public class FlowResponse{
        @InvocableVariable(label='Amount' description='Amount after discount')
        public Decimal amount;
    }

}