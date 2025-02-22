package top.huangshi10492.boom

import android.content.Intent
import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.nfc.NfcAdapter
import android.os.Build.VERSION.SDK_INT
import android.os.Bundle
import android.os.Parcelable
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private var data:String = "null"
    private val CHANNEL = "top.huangshi10492.boom/intent"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "intent") {
                result.success(data)
                data = "null"
            }
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleSend(intent)
    }
    private fun handleSend(intent: Intent){
        if (intent.action == "android.nfc.action.TECH_DISCOVERED") {
            data = readNfcTag(intent)
        }
    }

    /**
     * 读取NFC标签文本数据
     */
    private fun readNfcTag(intent: Intent): String {
        val rawMsgs = intent.getParcelableArrayExtra(
            NfcAdapter.EXTRA_NDEF_MESSAGES,
        )
        var msgs: Array<NdefMessage?>? = null
        var contentSize = 0
        if (rawMsgs != null) {
            msgs = arrayOfNulls(rawMsgs.size)
            for (i in rawMsgs.indices) {
                msgs[i] = rawMsgs[i] as NdefMessage
                contentSize += msgs[i]!!.toByteArray().size
            }
        }
        try {
            if (msgs != null) {
                val record = msgs[0]!!.records[0]
                return parseTextRecord(record)
            }
        } catch (e: Exception) {
            return e.toString()
        }
        return "null"
    }

    private fun parseTextRecord(ndefRecord: NdefRecord): String {
        /**
         * 判断数据是否为NDEF格式
         */
        //判断TNF

        //判断可变的长度的类型
        return try {
            //获得字节数组，然后进行分析
            val payload = ndefRecord.payload
            //下面开始NDEF文本数据第一个字节，状态字节
            //判断文本是基于UTF-8还是UTF-16的，取第一个字节"位与"上16进制的80，16进制的80也就是最高位是1，
            //其他位都是0，所以进行"位与"运算后就会保留最高位
            val textEncoding =
                if (payload[0].toInt() and 0x80 == 0) "UTF-8" else "UTF-16"
            //3f最高两位是0，第六位是1，所以进行"位与"运算后获得第六位
            val languageCodeLength = payload[0].toInt() and 0x3f
            //下面开始NDEF文本数据后面的字节，解析出文本
            String(
                payload, languageCodeLength + 1,
                payload.size - languageCodeLength - 1, charset(textEncoding)
            )
        } catch (e: java.lang.Exception) {
            return e.toString()
        }
    }
}
