ALTER TABLE rhnVirtualInstance
    ADD COLUMN IF NOT EXISTS payg CHAR(1)
       DEFAULT ('N');
