方法 2: 使用 sys.modules 动态重定向模块
如果模块结构重构后，旧模块完全不存在了，或者你需要更加灵活的兼容性处理，可以使用 sys.modules 重定向模块路径。

python
Copy code
import sys
import new_module

# 动态将旧模块名指向新模块
sys.modules['old_module'] = new_module
这样，当旧代码尝试导入 old_module 时，实际上导入的是 new_module。