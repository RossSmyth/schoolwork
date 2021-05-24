fprintf('hi')
bar = event.listener(@input, '\n', @foo);
pause(2)

function foo(~, ~)
fprintf('hi')
end