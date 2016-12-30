```c

pm_stay_awake() {
    wakeup_source_activate() {
        // in_progress_event += 1
        atomic_inc_return(&combined_event_count);
    }
}

pm_relax() {
    wakeup_source_activate() {
        // in_progress_event -= 1, registered_event += 1
        atomic_add_return(MAX_IN_PROGRESS, &combined_event_count);
    }
}

suspend_enter() {
    if (pm_wakeup_pending() {
        // get in_progress_event and store it in inpr
        split_counters(&cnt, &inpr);
        return (inpr > 0);)
    }
}
