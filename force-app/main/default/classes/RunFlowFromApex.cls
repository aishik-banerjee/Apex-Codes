public with sharing class RunFlowFromApex {
    public static void callFlow() {

        Map<String,Object> params = new Map<String,Object>();
        params.put('accountId', '001gK000003rwk5QAA');

        Flow.Interview.RunFlowFromApex flowRun = new Flow.Interview.RunFlowFromApex(params);
        flowRun.start();

        String accName = (String)flowRun.getVariableValue('accountName');
        Decimal numEmployees = (Decimal)flowRun.getVariableValue('numberOfEmployees');
        System.debug('The new account name is: ' + accName + ' and it has: ' + numEmployees + ' employees.');
    }
}