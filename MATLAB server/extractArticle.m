function response = extractArticle(encoded_url)
    
    url = urldecode(encoded_url);
    import py.newspaper.Article;
    article = Article(url);
    article.download();
    
    %article.html;
    
    article.parse();
    
    %article.authors
    %article.publish_date
    %article.text
    
    article.nlp();
    
    %article.keywords
    %article.summary
    
    response = struct('url', url, 'title', string(article.title), 'text',  string(article.text), ...
                'summary', string(article.summary));
end