/**
 * Copyright (c) 2008 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public License,
 * version 2 (GPLv2). There is NO WARRANTY for this software, express or
 * implied, including the implied warranties of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. You should have received a copy of GPLv2
 * along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 * 
 * Red Hat trademarks are not licensed under GPLv2. No permission is
 * granted to use or replicate Red Hat trademarks that are incorporated
 * in this software or its documentation. 
 */
package com.redhat.rhn.frontend.action.kickstart.tree;

import com.redhat.rhn.frontend.struts.RequestContext;
import com.redhat.rhn.manager.PersistOperation;
import com.redhat.rhn.manager.kickstart.tree.BaseTreeEditOperation;
import com.redhat.rhn.manager.kickstart.tree.TreeEditOperation;

import org.apache.struts.action.DynaActionForm;

/**
 * TreeEditAction
 * @version $Rev$
 */
public class TreeEditAction extends BaseTreeAction {

    /**
     * {@inheritDoc}
     */
    protected void processRequestAttributes(RequestContext rctx, PersistOperation opr) {
        BaseTreeEditOperation bte = (BaseTreeEditOperation) opr;
        rctx.getRequest().setAttribute(RequestContext.KSTREE, bte.getTree());
        
        super.processRequestAttributes(rctx, opr);
    }

    /**
     * {@inheritDoc}
     */
    protected String getSuccessKey() {
        return "tree.edit.success";
    }

    /**
     * {@inheritDoc}
     */
    protected PersistOperation getCommand(RequestContext ctx) {
        return new TreeEditOperation(ctx.getRequiredParam(RequestContext.KSTREE_ID), 
                ctx.getCurrentUser());
    }

    /**
     * {@inheritDoc}
     */
    protected void processFormValues(PersistOperation operation,
            DynaActionForm form) {
        BaseTreeEditOperation bte = (BaseTreeEditOperation) operation;
        form.set(BASE_PATH, bte.getTree().getBasePath());
        form.set(CHANNEL_ID, bte.getTree().getChannel().getId());
        form.set(LABEL, bte.getTree().getLabel());
        form.set(INSTALL_TYPE, bte.getTree().getInstallType().getLabel());
    }

}
