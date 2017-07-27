1. TQ.Q(`late-init`);
2. TQ.Q(`queue_property_triggers`);
3. execute `late-init`{setprop(`aaa.bbb=ccc`), TQ.Q(`on boot`)};
4. execute `queue_property_triggers`{TQ.Q(`empty`), set `property_triggers_enabled`};
5. execute `on boot`{setprop&TQ.Q(`tp.fw.update=1`)};
6. execute `empty`{execute `on aaa.bbb=ccc` `on tp.fw.update=1`};
7. execute `on tp.fw.update=1`;
