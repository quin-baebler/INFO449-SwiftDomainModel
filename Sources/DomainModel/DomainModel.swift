import Foundation
struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ targetCurrency: String ) -> Money{
        var convertedAmount: Double = Double(self.amount)
            if (self.currency != "USD") {
                convertedAmount = convertUSD(self.currency)
            }
                switch targetCurrency {
                case "GBP":
                    convertedAmount = Double(convertedAmount) * 0.5
                case "EUR":
                    convertedAmount = Double(convertedAmount) * 1.5
                case "CAN":
                    convertedAmount = Double(convertedAmount) * 1.25
                case "USD":
                    convertedAmount = Double(self.amount)
                default:
                    fatalError("Unexpected target currency: \(targetCurrency)")
                }
        return Money(amount: Int(convertedAmount), currency: targetCurrency)
    }
    
    
    private func convertUSD(_ currencyFrom: String) -> Double {
        switch currencyFrom {
        case "GBP":
            return Double(amount) / 0.5
        case "EUR":
            return Double(amount) / 1.50
        case "CAN":
            return Double(amount) / 1.25
        case "USD":
           return Double(self.amount)
        default:
          fatalError("Unexpected target currency: \(currencyFrom)")
        }
     }
    
    func add(_ otherMoney: Money) -> Money {
        let convertedMoney = Money(amount: self.amount, currency: self.currency).convert(otherMoney.currency)
        let convertedAmount = convertedMoney.amount + otherMoney.amount
        return Money(amount: convertedAmount, currency: otherMoney.currency)
    }
    
    func subtract(_ otherMoney: Money) -> Money {
        let convertedMoney = Money(amount: self.amount, currency: self.currency).convert(otherMoney.currency)
        let convertedAmount = convertedMoney.amount - otherMoney.amount
        return Money(amount: convertedAmount, currency: otherMoney.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let wage):
          return Int(wage * Double(hours))
        case .Salary(let salary):
          return Int(salary) // Salary income is the same as yearly amount
        }
    }
   
    func raise(byAmount amount: Double) {
        switch type {
        case .Hourly(var wage):
          wage += amount
          type = .Hourly(wage)
        case .Salary(var salary):
          salary += UInt(amount)
          type = .Salary(salary)
        }
    }
      
      // Overloaded raise function to accept percentage increase
    func raise(byPercent percentage: Double) {
        switch type {
        case .Hourly(var wage):
            type = .Hourly(wage * (1.0 + percentage))
        case .Salary(var salary):
            type = .Salary(UInt(Double(salary) * (1.0 + percentage)))
        }
      }
    }

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var _job: Job?
    var _spouse: Person?
    
    
    var job: Job? {
        get { return _job }
        set {
            if age > 16 {
                _job = newValue
            } else {
                _job = nil
            
            }
        }
    }

    var spouse: Person? {
        get { return _spouse }
        set {
            if age > 21 {
                _spouse = newValue
            } else {
                _spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int, job: Job? = nil, spouse: Person? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }
    
    func toString() -> String {
        
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job)) spouse:\(String(describing: spouse))]"
    }

}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    init(spouse1: Person, spouse2: Person) {
        self.members = [spouse1, spouse2]
    }
    
    func haveChild(_ child: Person) -> Bool {
        if (members[0].age >= 21 && members[1].age >= 21) {
            members.append(child)
            return true
        }
        return false
    }
    
    func householdIncome() -> Int{
        var combinedIncome = 0
        for member in members {
            if let job = member.job {
                switch job.type {
                case .Hourly(let wage):
                    combinedIncome += Int(wage * 2000)
                case .Salary(let salary):
                    combinedIncome += Int(salary)
                }
            }
        }
        return combinedIncome
    }
    
}
