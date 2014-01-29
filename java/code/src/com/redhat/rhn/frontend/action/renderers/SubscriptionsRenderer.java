/**
 * Copyright (c) 2014 SUSE
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

package com.redhat.rhn.frontend.action.renderers;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;

import com.redhat.rhn.frontend.taglibs.list.ListTagHelper;
import com.redhat.rhn.manager.setup.MirrorCredentials;
import com.redhat.rhn.manager.setup.SetupWizardManager;
import com.suse.manager.model.ncc.Subscription;

/**
 * Asynchronously render page content that is loaded from NCC.
 */
public class SubscriptionsRenderer {

    // The logger for this class
    private static Logger logger = Logger.getLogger(SubscriptionsRenderer.class);

    // Attribute keys
    public static final String ATTRIB_SUCCESS = "success";

    // URL of the page to render
    private static final String PAGE_URL = "/WEB-INF/pages/admin/setup/mirror-credentials-async.jsp";

    /**
     * Get subscriptions for credentials and asynchronously render the page fragment.
     * @throws IOException 
     * @throws ServletException 
     */
    public String renderAsync(Long id) throws ServletException, IOException {
        WebContext webContext = WebContextFactory.get();
        HttpServletRequest request = webContext.getHttpServletRequest();

        // Load credentials for given ID and the subscriptions
        MirrorCredentials creds = SetupWizardManager.findMirrorCredentials(id);
        if (logger.isDebugEnabled()) {
            logger.debug("Render subscriptions for user: " + creds.getUser());
        }
        List<Subscription> subs = SetupWizardManager.listSubscriptions(creds);
        request.setAttribute(ATTRIB_SUCCESS, subs != null);

        // Set the "parentUrl" for the form (in rl:listset)
        request.setAttribute(ListTagHelper.PARENT_URL, "");
        HttpServletResponse response = webContext.getHttpServletResponse();
        return RendererHelper.renderRequest(PAGE_URL, request, response);
    }
}
