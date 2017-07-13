%% Call Python from MATLAB
% These examples show how to use Python(R) language 
% functions and modules within MATLAB(R). The first example calls a 
% text-formatting module from the Python standard library. The
% second example shows how to use a third-party module,
% <http://www.crummy.com/software/BeautifulSoup/ Beautiful Soup>. 
% If you want to run that example, follow the guidelines
% in the step for installing the module.
%
% MATLAB supports the reference implementation of Python, 
% often called CPython, versions 2.7, 3.4, 3.5, and 3.6.
% If you are on a Mac or Linux platform, you already have
% Python installed. If you are on Windows, you need to install 
% a distribution, such as those found at <https://www.python.org/download>, 
% if you have not already done so. For more information, see 
% <docid:matlab_external.bujjwjn>.
%

% Copyright 2014-2017 The MathWorks, Inc.

%% Call a Python Function to Wrap Text in a Paragraph
% MATLAB has equivalencies for much of the
% <http://docs.python.org/2/library/ Python standard library>, but not 
% everything. For example, |textwrap| is a module for
% formatting blocks of text with carriage returns and other conveniences.
% MATLAB also provides a |textwrap| function, but it only wraps text to fit
% inside a UI control.
%%
% Create a paragraph of text to play with.

T = 'MATLAB(R) is a high-level language and interactive environment for numerical computation, visualization, and programming. Using MATLAB, you can analyze data, develop algorithms, and create models and applications. The language, tools, and built-in math functions enable you to explore multiple approaches and reach a solution faster than with spreadsheets or traditional programming languages, such as C/C++ or Java(TM).';
%% Convert a Python String to a MATLAB String
% Call the |textwrap.wrap| function by typing the characters |py.| in front
% of the function name. Do not type |import textwrap|.

wrapped = py.textwrap.wrap(T);
whos wrapped

%%
% |wrapped| is a Python list, which is a list of Python strings. 
% MATLAB shows this type as |py.list|.

%%  
% Convert |py.list| to
% a cell array of Python strings. 
wrapped = cell(wrapped);
whos wrapped
%%
% Although |wrapped| is a MATLAB cell array, 
% each cell element is a Python string.

wrapped{1}
%%
% Convert the Python strings to MATLAB strings using the |char| function.

wrapped = cellfun(@char, wrapped, 'UniformOutput', false);
wrapped{1}
%% 
% Now each cell element is a MATLAB string.
%% Customize the Paragraph
% Customize the output of the paragraph using keyword arguments.
%
% The previous code uses the |wrap| convenience
% function, but the module provides many more options using the 
% |py.textwap.TextWrapper| functionality.
% To use the options, call |py.textwap.TextWrapper| with 
% keyword arguments described at  
% <https://docs.python.org/2/library/textwrap.html#textwrap.TextWrapper>.
%
% Create keyword arguments using the MATLAB |pyargs| function with 
% a comma-separated list of name/value pairs. |width| formats 
% the text to be 30 characters wide. The |initial_indent| and 
% |subsequent_indent| 
% keywords begin each line with the comment character, |%|, used by 
% MATLAB.

tw = py.textwrap.TextWrapper(pyargs(...
    'initial_indent', '% ', ...
    'subsequent_indent', '% ', ...
    'width', int32(30)));
wrapped = wrap(tw,T);
%%
% Convert to a MATLAB argument and display the results.
wrapped = cellfun(@char, cell(wrapped), 'UniformOutput', false);
fprintf('%s\n', wrapped{:})

%% Use Beautiful Soup, a Third-Party Python Module
% This example shows how to use a third-party  
% module, <http://www.crummy.com/software/BeautifulSoup/ Beautiful Soup>,
% a tool for parsing HTML. If you want to run the example, you need 
% to install this module using |apt-get|, |pip|, |easy_install|, or other
% tool you use to install Python modules.
%
% First, find a Web page that includes a table of data. This example uses a
% table of the population of the world from the following 
% English-language Wikipedia site.
% This example assumes the third table contains the population data, 
% and assumes the country name is in the second column 
% and the third column contains the population.

html = webread('http://en.wikipedia.org/wiki/List_of_countries_by_population');
soup = py.bs4.BeautifulSoup(html,'html.parser');

%%
% Next, extract all of the table data from the HTML, creating a cell
% array. If you want a deeper understanding of
% what is happening, refer to the 
% <http://www.crummy.com/software/BeautifulSoup/bs4/doc/
% documentation for Beautiful Soup>.

tables = soup.find_all('table');
t = cell(tables);

%%
% The third table is the one of interest; extract its rows.

c = cell(t{3}.find_all('tr'));
c = cell(c)';

%%
% Now loop over the cell array, extracting the country name and population
% from each row, found in the second and third columns respectively.

countries = cell(size(c));
populations = nan(size(c));

for i = 1:numel(c)
    row = c{i};
    row = cell(row.find_all('td'));
    if ~isempty(row)
        countries{i} = char(row{2}.get_text());
        populations(i) = str2double(char(row{3}.get_text()));
    end
end

%%
% Finally, create a MATLAB table from the data, and eliminate any
% lingering |nan| values; these NaNs represented invalid rows when
% importing the HTML.

data = table(countries, populations, ...
    'VariableNames', {'Country', 'Population'});
data = data(~isnan(data.Population), :);

%%
% Trim the tail end of the table and make a pie chart

restofWorldPopulation = sum(data.Population(11:end));
data = data(1:10, :);
data = [data;table({' Rest of World'}, restofWorldPopulation, ...
    'VariableNames', {'Country', 'Population'})]
pie(data.Population)
legend(data.Country, 'Location', 'EastOutside');
title('Distribution of World Population')

%% Learn More
%
% It is sufficient to remember that
% Python is yet another potential source of libraries for the MATLAB
% user. If you want to learn about moving data between MATLAB and
% Python, including Python data types such as tuples and dictionaries, 
% see <docid:matlab_doccenter.buik_wp-1>.
%
