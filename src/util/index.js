/**
 * @author ChenZhiyong
 * @description 工具
 */
const xlsx = require('xlsx')


export function analysisExcel (filename, taxNumber) {
  // console.log('读取文件: ', filename)
  // console.log('要核对的发票号: ', taxNumber)
  const workbook = xlsx.readFile(filename)
  const sheetNames = workbook.SheetNames
  let foundedItem = null

  sheetNames.forEach(sheetName => {
    const sheet = workbook.Sheets[sheetName]
    const sheetArray = xlsx.utils.sheet_to_json(sheet) 

    sheetArray.forEach(item => {
      if (item['发票票号'] == taxNumber) {
        // console.log('已经存在发票号: ', item['发票票号'], item)
        foundedItem = item
      }
    })
  });

  // console.log('未查到此发票号: ', taxNumber, ' 可以使用')
  return foundedItem
}