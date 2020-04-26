<template>
  <q-page class="flex flex-center">
    <vue-dropzone v-show="showUpload" ref="imageDropzone" id="dropzone" :options="dropzoneOptions" @vdropzone-success="uploadSuccess"></vue-dropzone>
    <div v-show="!showUpload" class="row">
      <img ref="snipImage" :src="imageData" style="max-width: 1000px; max-height: 1000px" />
      <q-input v-model="text" filled autogrow readonly/>
    </div>
  </q-page>
</template>

<script>
  import vue2Dropzone from 'vue2-dropzone'
  import 'vue2-dropzone/dist/vue2Dropzone.min.css'
  let dragsnip = require("dragsnip");
  let axios = require("axios");
  import { copyToClipboard } from 'quasar'

  export default {
  name: 'PageIndex',
  data: () => {
    return {
      dropzoneOptions: {
        url: 'https://ocr-service.conflee.de/image',
        paramName: "image",
        acceptedFiles: "image/*",
        thumbnailWidth: 150,
        maxFilesize: 1,
        language : {
          dictDefaultMessage: 'Drop your image with text here',
        }
      },
      id: "",
      secret: "",
      showUpload: true,
      imageData: "",
      text: ""
    }
  },
  methods: {
    uploadSuccess(file, response) {
      let data = JSON.parse(response);
      this.id = data.id;
      this.secret = data.secret;
      this.showUpload = false;
      this.imageData = file.dataURL;
      setTimeout((() => {
        dragsnip.register(this.$refs["snipImage"], (start, end) => {
          console.log(start);
          console.log(end);
          axios.get(`https://ocr-service.conflee.de/snip?id=${data.id}&secret=${data.secret}&x1=${start.x}&y1=${start.y}&x2=${end.x}&y2=${end.y}`)
            .then((response) => {
              if(response.status === 200) {
                this.text = response.data;
                copyToClipboard(this.text);
              }
          });
        })
      }), 500)

    }
  },
  components: {
    vueDropzone: vue2Dropzone
  },
}
</script>
