<template>
  <div class="home">
    <ul class="help">
      使用指南：
      <li>1. 打开已经汇总的excel文件，仅支持.xlsx格式</li>
      <li>2. 输入要查询的发票号</li>
    </ul>
    <button 
      class="home__btn"
      @click="onOpenExcelFiles"
    >打开要核对的Excel文件</button>
    <div class="home__input_wrapper" >
      <input 
        class="home__input"
        v-model="taxNumber"
        placeholder="请输入发票号"
      />
      <button 
        class="home__btn home__btn_check"
        @click="onCheckTaxNumber"
      >查询</button>
    </div>
    <div class="home__files">
      <div 
        class="home__file_info"
        v-for="(item, index) in fileList"
        :key="`file_${index}`"
      >
        <h5>文件: {{ item.fileName }}</h5>
        <ul>
          <li  
            v-for="(infoKey, index) in Object.keys(item.foundedInvoice)"
            :key="`founded_${index}`"
          >
            {{ infoKey }}: {{ item.foundedInvoice[infoKey] }}
          </li>
        </ul>
      </div>
    </div>
    <div class="home__result">
      <span 
        v-if="showErrMsg"
        class="home__result_tips"
      >{{ errMsg }}</span>
    </div>
  </div>
</template>

<script>
import { remote } from 'electron'
const { Menu, MenuItem, dialog } = remote
import { analysisExcel } from '../util'

export default {
  data () {
    return {
      fileList: [],
      taxNumber: '',
      errMsg: '',
      showErrMsg: false,
    }
  },

  mounted () {
    // console.log('analysisExcel = ', analysisExcel)
  },

  methods: {
    async onOpenExcelFiles () {
      console.log('打开文件')
      const { canceled, filePaths } = await dialog.showOpenDialog({ 
        properties: [ 'openFile', 'multiSelections' ],
        filters: [
          { name: 'All Files', extensions: ['xlsx'] }
        ]
      });

      this.fileList = filePaths.map(item => ({
        fileName: item,
        foundedInvoice: {},
      }))

      this.result = this.fileList
    },

    onCheckTaxNumber () {
      if (this.taxNumber.length === 0) {
        this.errMsg = '请先输入发票号'
        this.showErrMsg = true
        return
      } else if (this.fileList.length === 0) {
        this.errMsg = '请选择要查询的Excel文件，(.xlsx格式)'
        this.showErrMsg = true
      } else {
        console.log('清空错误信息')
        this.errMsg = '查询中...'
        this.showErrMsg = true
      }
      
      const foundedInvoice = []
      this.fileList.forEach((file, index) => {
        foundedInvoice[index] = analysisExcel(file.fileName, this.taxNumber)
      })

      // console.log('foundedInvoice = ', foundedInvoice)

      const newFileList = this.fileList.map((item, index) => ({
        ...item,
        foundedInvoice: foundedInvoice[index],
      }))

      this.fileList = newFileList
      this.errMsg = ''
      this.showErrMsg = false
    },

  },
}
</script>
<style scoped>
.home {
  text-align: left;
  padding: 10px;
}

.home__btn {
  background: #E6454A;
  border-radius: 8px;
  width: 300px;
  height: 50px;
  font-family: PingFangSC-Medium;
  font-size: 20px;
  color: #FFFFFF;
  letter-spacing: 0.43px;
  text-align: center;
  line-height: 36px;
  transition: all 0.3s ease;
}

.home__btn:focus {
  outline: 0;
}

.home__btn:hover {
  background: rgba(230, 69, 74, 0.5);
}

.home__files {
  text-align: left;
}

.home__input_wrapper {
  margin-top: 20px;
  text-align: left;
}

.home__input {
  width: 300px;
  height: 30px;
  font-family: PingFangSC-Medium;
  font-size: 20px;
  border: 1px solid #5f5f5f;
  transition: all 0.3s ease;
}

.home__input:focus {
  outline: 0;
  border: 1px solid #E6454A;
}

.home__btn_check {
  width: 100px;
  height: 50px;
  margin-left: 20px;
}

.home__result {
  font-family: PingFangSC-Medium;
  font-size: 14px;
  text-align: left;
}

.home__result_tips {
  color: #E6454A;
}

.home__file_info {
  background: #F5F5F5;
  padding: 20px;
  border-radius: 4px;
  margin-bottom: 20px;
}
</style>