package cn.bc.identity.dao;

import cn.bc.core.dao.CrudDao;
import cn.bc.identity.domain.Role;

import java.util.List;
import java.util.Map;

/**
 * 角色Dao接口
 *
 * @author dragon
 */
public interface RoleDao extends CrudDao<Role> {
  /**
   * 获取指定类型和状态的Role信息
   *
   * @param types   类型列表
   * @param statues 状态列表
   * @return 返回结果中的元素Map格式为：
   * <ul>
   * <li>id -- Role的id</li>
   * <li>type -- Role的type</li>
   * <li>code -- Role的code</li>
   * <li>name -- Role的name</li>
   * </ul>
   */
  List<Map<String, String>> find4option(Integer[] types, Integer[] statues);

  /**
   * 获取角色的名称
   *
   * @param roleId 角色ID
   * @return 角色名称
   */
  String getRoleNameById(Long roleId);

  /**
   * 为角色分配资源
   *
   * @param roleId      角色ID
   * @param resourceIds 资源ID列表
   * @return 实际添加的条数
   */
  int addResource(Long roleId, Long[] resourceIds);

  /**
   * 删除资源与角色的关联
   *
   * @param roleId      角色ID
   * @param resourceIds 资源ID列表
   * @return 实际删除的条数
   */
  int deleteResource(Long roleId, Long[] resourceIds);

  /**
   * 为角色分配 Actor
   *
   * @param roleId   角色ID
   * @param actorIds Actor的ID列表
   * @return 实际添加的条数
   */
  int addActor(Long roleId, Long[] actorIds);

  /**
   * 删除Actor与角色的关联
   *
   * @param roleId   角色ID
   * @param actorIds Actor的ID列表
   * @return 实际删除的条数
   */
  int deleteActor(Long roleId, Long[] actorIds);
}