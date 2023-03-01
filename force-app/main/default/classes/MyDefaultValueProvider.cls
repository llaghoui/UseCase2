public class MyDefaultValueProvider extends TestDataFactory.DefaultValueProvider{

    public override Datetime getDateTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
        return Datetime.newInstance(2023, 1, 1, 12, 0, 0).addDays(counter);
    }

}