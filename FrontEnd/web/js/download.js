function download(url,name){
          axios({
              url:url,
              method:'GET',
              responseType: 'blob'
      })
      .then((response) => {
             const url = window.URL
             .createObjectURL(new Blob([response.data]));
                    const link = document.createElement('a');
                    link.href = url;
                    link.setAttribute('download', name);
                    document.body.appendChild(link);
                    link.click();
      })
      }