import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    
    init(name: String, amount: Int, price: Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }
}

//TODO: Definir os erros
enum VendingMachineError: Error {
    case productNotFound
    case productUnvalible
    case productStuck
    case insuficientFunds
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Nao tem isso"
        case .productUnvalible:
            return "Acabou"
        case .productStuck:
            return "Ficou preso"
        case .insuficientFunds:
            return "Dinheiro insuficiente"
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    func getProduct(named name: String, with money: Double) throws {
        self.money += money
        //TODO: achar o produto que o cliente quer
        var produtoOptional = estoque.first { (produto) -> Bool in
            return produto.name == name
        }
        
        guard let produto = produtoOptional else { throw VendingMachineError.productNotFound }
        
        //TODO: ver se ainda tem esse produto
        guard produto.amount > 0 else { throw VendingMachineError.productUnvalible }
        
        //TODO: ver se o dinheiro é o suficiente pro produto
        guard produto.price <= self.money else { throw VendingMachineError.insuficientFunds }
        
        self.money -= produto.price
        produto.amount -= 1
        
        //TODO: entregar o produto
        if Int.random(in: 0...100) < 10 {
            throw VendingMachineError.productStuck
        }
    }
    
    func getTroco() -> Double {
        //TODO: devolver o dinheiro que não foi gasto
        let money = self.money
        self.money = 0.0
        
        return money
    }
}

let vendingMachine = VendingMachine(products: [
    VendingMachineProduct(name: "Carregador de iPhone", amount: 5, price: 150.00),
    VendingMachineProduct(name: "Cebolitos", amount: 2, price: 5.00),
    VendingMachineProduct(name: "Umbrella", amount: 5, price: 120.00)
])
    do {
        try vendingMachine.getProduct(named: "Umbrella", with: 130.00)
        try vendingMachine.getProduct(named: "Cebolitos", with: 0.0)
        print("Deu bom")
    } catch VendingMachineError.productStuck {
        print("Pedimos desculpas, mas o produto ficou preso")
    } catch VendingMachineError.insuficientFunds {
        print("Nao ha dinheiro o suficiente! Por favor insira mais cedulas")
    } catch VendingMachineError.productNotFound {
        print("Tururuuu...Nao temos esse produto no momento, insira outro")
    } catch VendingMachineError.productUnvalible {
        print("Produto indisponivel, selecione outro por favor")
}


