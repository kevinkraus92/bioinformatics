google.load('search', '1');

var imageSearch;

function searchComplete() {

        // Check that we got results
        if (imageSearch.results && imageSearch.results.length > 0) {

          // Grab our content div, clear it.
          var contentDiv = document.getElementById('content');
          contentDiv.innerHTML = '';

          // Loop through our results, printing them to the page.
          var results = imageSearch.results;
          var i = 0
            // For each result write it's title and image to the screen
            var result = results[i];
            var imgContainer = document.createElement('div');
            var title = document.createElement('div');

          // We use titleNoFormatting so that no HTML tags are left in the 
          // title
          title.innerHTML = result.titleNoFormatting;
          var newImg = document.createElement('img');

          // There is also a result.url property which has the escaped version
          newImg.src=result.tbUrl;

          console.log(result.tbUrl)
        }
      }

      function searchImage() {

        // Create an Image Search instance.
        imageSearch = new google.search.ImageSearch();

        // Set searchComplete as the callback function when a search is 
        // complete.  The imageSearch object will have results in it.
        imageSearch.setSearchCompleteCallback(this, searchComplete, null);

        // Find me a beautiful car.
        imageSearch.execute(string);

        
      }