-- Remove inconsistent config channel state revisions where config channel org is
-- not equal to staterevision org.
DELETE FROM suseStateRevisionConfigChannel scc WHERE
NOT EXISTS (SELECT 1
            FROM rhnConfigChannel cc, suseStateRevision sr, web_contact wc
            WHERE cc.id = scc.config_channel_id
            AND scc.state_revision_id = sr.id
            AND sr.creator_id = wc.id
            AND wc.org_id = cc.org_id);


-- Recalculate positions for entries after removing some of them on the previous step.
-- This SQL query will keep the actual position ordering but ensuring there is no missing position.
UPDATE suseStateRevisionConfigChannel
SET position = (
    SELECT rank
    FROM (
        SELECT state_revision_id, config_channel_id, position, (row_number() OVER (PARTITION BY state_revision_id ORDER BY position ASC)) rank
        FROM suseStateRevisionConfigChannel scc
    ) ranking
    WHERE config_channel_id = suseStateRevisionConfigChannel.config_channel_id
    AND state_revision_id = suseStateRevisionConfigChannel.state_revision_id);
