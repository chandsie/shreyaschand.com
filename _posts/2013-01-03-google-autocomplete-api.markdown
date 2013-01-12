---
layout: post
title: Google Autocomplete "API"
---
Recently, I've been working on a personal side project that makes use of the [YouTube API](https://developers.google.com/youtube/). As part of the project, I needed to implement a search bar, complete with autocomplete suggestions. Basically, I wanted to mimic the functionality of the YouTube search bar.

![Youtube Search Autocomplete](/img/blog/google-autocomplete-api/youtube-search-autocomplete.png)

However, it turns out that there is no documented method to get that list of autocomplete suggestions. Fortunately, I discovered, with the help of some google-fu, that it is possible to  tap into that autocomplete stream by hitting this base URL:


`http://suggestqueries.google.com/complete/search`


Through some trial and error, I was able to construct a table of the necessary/available GET request parameters.

<table>
<thead>
<tr>
<th>Parameter</th><th>Description</th><th>Options</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>q</code></td><td>Specifies the search to complete.<br>
<br>
(<em>Required</em>. Duh.)</td><td>Your search term.</td>
</tr>
<tr>
<td><code>client</code> or <code>output</code></td><td>Determines the type of response you want.<br>
<br>
(<em>Required</em>. You must specify either one of the two. If both are provided, <code>client</code> takes precedence)</td><td>For JSON, use <code>firefox</code>.<br>
For XML, use <code>toolbar</code>.<br>
For <a href="http://stackoverflow.com/questions/2067472/please-explain-jsonp">JSONP</a> (only supported with <code>client</code>), use <code>youtube</code>.</td>
</tr>
<tr>
<td><code>jsonp</code></td><td>Specifies the name of the JSONP callback function. <br>
<br>
(<em>Optional</em>. Defaults to <code>window.google.ac.h</code>.)</td><td>Your JSONP callback function's name.</td>
</tr>
<tr>
<td><code>ds</code></td><td>Include this option to restrict the search to a particular site.<br>
<br>
(<em>Optional</em>. Defaults to plain ol' google search.)</td><td>For YouTube (!), use <code>yt</code>.</td>
</tr>
<tr>
<td><code>hl</code></td><td>Chooses the language in which the search is being performed.<br>
<br>
(<em>Optional</em>. Defaults to English. (<code>en</code>))</td><td>Any google-supported language's 2-letter abbreviation (<a href="http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639-1</a>).</td>
</tr>
</tbody>
</table>

Here are some examples with their outputs:

`http://suggestqueries.google.com/complete/search?q=ob&client=toolbar`

[![Autocomplete Sample ob-xml](/img/blog/google-autocomplete-api/autocomplete-sample-ob-xml-150x150.png)](/img/blog/google-autocomplete-api/autocomplete-sample-ob-xml.png)


`http://suggestqueries.google.com/complete/search?q=ob&client=firefox&hl=fr`

[![Autocomplete ob-json-fr](/img/blog/google-autocomplete-api/autocomplete-ob-json-fr-150x150.png)](/img/blog/google-autocomplete-api/autocomplete-ob-json-fr.png)

Keep in mind that this "API" is a bit of a hack; it was only meant for use by Google's own products. Thus, making a JSON or XML request to this service from your javscript code will result in the following error:

{% highlight javascript %}
XMLHttpRequest cannot load "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&q=te&output=firefox".
Origin "http://yourdomain.com" is not allowed by Access-Control-Allow-Origin
{% endhighlight %}


This problem of cross domain restrictions, though annoying, is relatively common and making a JSONP based request, by specifying `output = youtube`, was the method I employed to solve this problem. In my final implementation, I utilized [jQuery](http://jquery.com) and the [Autocomplete](http://jqueryui.com/autocomplete/) widget from [jQuery UI](http://jqueryui.com/). Here's the code I wrote, where `#search` is an input element of type text.


{% highlight javascript linenos %}
var suggestCallBack; // global var for autocomplete jsonp

$(document).ready(function () {
    $("#search").autocomplete({
        source: function(request, response) {
            $.getJSON("http://suggestqueries.google.com/complete/search?callback=?",
                {
                  "hl":"en", // Language
                  "ds":"yt", // Restrict lookup to youtube
                  "jsonp":"suggestCallBack", // jsonp callback function name
                  "q":request.term, // query term
                  "client":"youtube" // force youtube style response, i.e. jsonp
                }
            );
            suggestCallBack = function (data) {
                var suggestions = [];
                $.each(data[1], function(key, val) {
                    suggestions.push({"value":val[0]});
                });
                suggestions.length = 5; // prune suggestions list to only 5 items
                response(suggestions);
            };
        },
    });
});
{% endhighlight %}

And finally, here's a screenshot of my finished YouTube search bar.

[![My Autocopmlete Search Bar](/img/blog/google-autocomplete-api/my-autocomplete-search-bar-300x158.png)](/img/blog/google-autocomplete-api/my-autocomplete-search-bar.png)

Let me know what you think: Know any better ways to do this? Know of any other GET parameters? Find somewhere that I goofed up?
