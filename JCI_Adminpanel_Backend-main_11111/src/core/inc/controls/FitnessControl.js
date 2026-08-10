import { DBController } from "../../database/DbController.js";
import { NotValid } from "../../errors/ErrorConstant.js";
import { resolvePublicMediaUrl } from "../../utils/mediaUrl.js";

export class FitnessControl {}

FitnessControl.Story = {
  create: async ({ memberId, imagePath }) => {
    if (!imagePath) {
      throw NotValid("image", "Image is required");
    }
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000);
    return await DBController.FitnessStory.create({
      member_id: memberId,
      image_path: imagePath,
      expires_at: expiresAt,
    });
  },

  listActive: async () => {
    const now = new Date();
    const stories = await DBController.FitnessStory.findActive(now);
    const byMember = new Map();

    for (const story of stories) {
      const plain = story.toJSON ? story.toJSON() : story;
      const member = await DBController.Models.Member.findByPk(plain.member_id);
      if (!member || member.status !== "active") continue;
      const key = plain.member_id;
      if (!byMember.has(key)) {
        byMember.set(key, {
          member_id: plain.member_id,
          member_name: member?.user_name || "Member",
          profile_pic: resolvePublicMediaUrl(member?.profile_pic || null),
          stories: [],
        });
      }
      byMember.get(key).stories.push({
        id: plain.id,
        image_url: resolvePublicMediaUrl(plain.image_path),
        created_at: plain.createdAt,
        expires_at: plain.expires_at,
      });
    }

    return Array.from(byMember.values());
  },

  deleteOwn: async ({ storyId, memberId }) => {
    const story = await DBController.FitnessStory.findById(storyId);
    if (!story) throw NotValid("story", "Story not found");
    const plain = story.toJSON();
    if (plain.member_id !== memberId) {
      throw NotValid("story", "You can only delete your own story");
    }
    await DBController.FitnessStory.deleteById(storyId);
    return { deleted: true };
  },

  purgeExpired: async () => {
    const now = new Date();
    const expired = await DBController.FitnessStory.findExpired(now);
    for (const story of expired) {
      await DBController.FitnessStory.deleteById(story.id);
    }
    return { purged: expired.length };
  },
};
