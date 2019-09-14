package dev.jideguru.crypto_app_ui

import org.web3j.crypto.Credentials
import org.web3j.protocol.http.HttpService
import org.web3j.protocol.Web3j
import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences
import org.web3j.abi.FunctionEncoder
import org.web3j.abi.TypeReference
import org.web3j.abi.datatypes.Function
import org.web3j.abi.datatypes.generated.Uint256
import org.web3j.crypto.ECKeyPair
import org.web3j.protocol.core.DefaultBlockParameterName
import org.web3j.protocol.core.methods.request.Transaction
import org.web3j.tx.gas.DefaultGasProvider.GAS_PRICE
import java.lang.reflect.Type
import java.math.BigInteger
import java.sql.Types.BINARY
import java.util.*
import okhttp3.OkHttpClient




class EthWrapper(privateKey:String,value:Int) {
    var privkey = BigInteger(privateKey, 16)
    var ecKey = ECKeyPair.create(privkey.toByteArray())
    val client = OkHttpClient()
    var web3 = Web3j.build(HttpService("https://testnet2.matic.network",client))
    var cs = Credentials.create(ecKey)
    fun getNonce():BigInteger{
        var ethGetTransactionCount = web3.ethGetTransactionCount(
                cs.address, DefaultBlockParameterName.LATEST).sendAsync().get()
        var nonce = ethGetTransactionCount.getTransactionCount()
        return nonce;
    }

    fun startWithdraw(value:Int):String{
        var bigValue:BigInteger = BigInteger.valueOf(value.toLong())*BigInteger.valueOf(1000000000000000000)
        var function: Function= Function(
                "withdraw",
                mutableListOf<Uint256>(Uint256(bigValue)) as List<org.web3j.abi.datatypes.Type<Any>>?,
                Collections.emptyList<TypeReference<*>>())
        var encodedFunction = FunctionEncoder.encode(function)
        val transaction:Transaction = Transaction.createFunctionCallTransaction(
                cs.address,
                getNonce()+BigInteger.valueOf(1),
                BigInteger.valueOf(10000000000), BigInteger.valueOf(4000000),"0xb35456a9b634cf85569154321596ee2d62e215ba", BigInteger.valueOf(0),encodedFunction
        )
        var transactionResponse = web3.ethSendTransaction(transaction).sendAsync().get()
        val transactionHash:String = transactionResponse.transactionHash
        return transactionHash
    }

}